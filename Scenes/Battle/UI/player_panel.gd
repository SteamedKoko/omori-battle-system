class_name PlayerPanel
extends Control

signal changed_mood(mood: String)

const PLAYER_PANEL = preload("uid://cfoptwsymul31")

@export var layout_position: Control.LayoutPreset
@export var player_data: PlayerData
@export var stats: Stats
@export var length_to_show_damage: float = 1

@onready var player_box: TextureRect = %PlayerBox
@onready var player_mood: RichTextLabel = %PlayerMood
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = %PlayerAnimatedSprite

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var juice_bar: TextureProgressBar = %JuiceBar
@onready var health_max_text: RichTextLabel = %HealthTextMax
@onready var health_current_text: RichTextLabel = %HealthTextCurrent
@onready var juice_max_text: RichTextLabel = %JuiceTextMax
@onready var juice_current_text: RichTextLabel = %JuiceTextCurrent
@onready var damage_text: Label = %DamageNumber

var sprite_frames: SpriteFrames
var sprite_state: SpriteStates:
	set = _update_sprite_state

var _mood: PlayerData.Emotions = PlayerData.Emotions.NEUTRAL
var mood: PlayerData.Emotions:
	set = _set_mood,
	get = _get_mood


enum SpriteStates {
	NEUTRAL,
	VICTORY,
	ANGRY,
	SAD,
	HAPPY,
	HURT,
	TOAST
}


func _ready():
	_set_panel_location(layout_position)

	damage_text.self_modulate = Color.TRANSPARENT

	health_bar.max_value = stats.max_hp
	juice_bar.max_value = stats.max_juice
	health_bar.value = stats.current_hp
	juice_bar.value = stats.current_juice

	health_max_text.text = str(stats.max_hp)
	juice_max_text.text = str(stats.max_juice)
	health_current_text.text = str(stats.current_hp)
	juice_current_text.text = str(stats.current_juice)

	player_data.player_stats.took_damage.connect(_took_damage)
	player_data.player_stats.toasted.connect(_toasted)


	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.play('normal')

	animation.stop()

func show_damage(amount: int) -> void:
	var tween: Tween = get_tree().create_tween()
	damage_text.text = str(amount)
	damage_text.self_modulate = Color.WHITE
	tween.tween_property(damage_text, "self_modulate", Color.WHITE, 1)
	tween.tween_property(damage_text, "self_modulate", Color.TRANSPARENT, 1)
	await get_tree().create_timer(length_to_show_damage).timeout

func _update_sprite_state(value: SpriteStates):
	if value == SpriteStates.NEUTRAL:
		animated_sprite.play('normal')
		return

	# Omori can't be toasted, loser
	if player_data.player_name.to_lower() == "omori" and value == SpriteStates.TOAST:
		animated_sprite.play('defeated')
		return

	animated_sprite.play(SpriteStates.keys()[value].to_lower())


func _toasted():
	sprite_state = SpriteStates.TOAST
	player_mood.text = ""

func _took_damage(_amount: int):
	#reduce hp via text and progressbar
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(health_bar, 'value', stats.current_hp, .3)
	tween.tween_property(health_current_text, 'text', str(stats.current_hp), .3)


func _set_panel_location(location: Control.LayoutPreset):
	player_box.set_anchors_and_offsets_preset(location, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)

func _set_mood(value: PlayerData.Emotions) -> void:
	_mood = value
	animated_sprite.play(PlayerData.Emotions.keys()[value].to_lower())
	var new_mood = player_data.Emotions.keys()[_mood].to_upper()
	player_mood.text = new_mood
	changed_mood.emit(new_mood)


func _get_mood() -> PlayerData.Emotions:
	return _mood

static func build(preset: Control.LayoutPreset, data: PlayerData) -> PlayerPanel:
	var instance: PlayerPanel = PLAYER_PANEL.instantiate()
	instance.layout_position = preset
	instance.player_data = data
	instance.stats = data.player_stats
	instance.sprite_frames = data.sprite_frames
	return instance
