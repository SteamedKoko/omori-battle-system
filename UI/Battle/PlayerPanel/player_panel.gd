class_name PlayerPanel
extends Control

signal changed_mood(mood: String)

const PLAYER_PANEL = preload("uid://cfoptwsymul31")

@export var layout_position: Control.LayoutPreset
@export var player_data: PlayerData
@export var stats: Stats
@export var portrait_labels: Dictionary[BattleEnums.Emotions, Texture2D]
@export var portrait_backgrounds: Dictionary[BattleEnums.Emotions, Texture2D]

@onready var player_box: TextureRect = %PlayerBox
@onready var portrait_text_emotion: TextureRect = %PlayerMood
@onready var portrait_back_emotion: TextureRect = %PortraitBackEmotion
@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = %PlayerAnimatedSprite
@onready var effect_container: MarginContainer = %EffectContainer

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var juice_bar: TextureProgressBar = %JuiceBar
@onready var health_max_text: RichTextLabel = %HealthTextMax
@onready var health_current_text: RichTextLabel = %HealthTextCurrent
@onready var juice_max_text: RichTextLabel = %JuiceTextMax
@onready var juice_current_text: RichTextLabel = %JuiceTextCurrent
@onready var damage_container: DamageContainer = %DamageContainer

var sprite_frames: SpriteFrames
var sprite_state: PlayerStates:
	set = _update_sprite_state

var _mood: BattleEnums.Emotions = BattleEnums.Emotions.NEUTRAL
var mood: BattleEnums.Emotions:
	set = _set_mood,
	get = _get_mood


enum PlayerStates {
	NEUTRAL,
	VICTORY,
	HURT,
	TOAST
}


func _ready():
	_set_panel_location(layout_position)

	damage_container.modulate = Color.TRANSPARENT

	health_bar.max_value = stats.max_hp
	juice_bar.max_value = stats.max_juice
	health_bar.value = stats.current_hp
	juice_bar.value = stats.current_juice

	health_max_text.text = str(stats.max_hp)
	juice_max_text.text = str(stats.max_juice)
	health_current_text.text = str(stats.current_hp)
	juice_current_text.text = str(stats.current_juice)

	player_data.player_stats.took_damage.connect(_took_damage)
	player_data.player_stats.used_juice.connect(func(_used: int): _update_juice())
	player_data.player_stats.toasted.connect(_toasted)


	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.play("neutral")

	animation.stop()


func _update_sprite_state(value: PlayerStates):
	if value == PlayerStates.NEUTRAL:
		animated_sprite.play("neutral")
		return

	# Omori can't be toasted, loser
	if player_data.player_name.to_lower() == "omori" and value == PlayerStates.TOAST:
		animated_sprite.play('defeated')
		return

	animated_sprite.play(PlayerStates.keys()[value].to_lower())


func _toasted():
	sprite_state = PlayerStates.TOAST
	portrait_text_emotion.text = ""

func _took_damage(_damage_taken: int):
	#reduce hp via text and progressbar
	_update_health()

func _update_health() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(health_bar, 'value', stats.current_hp, .3)
	tween.tween_property(health_current_text, 'text', str(stats.current_hp), .3)

func _update_juice() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(juice_bar, 'value', stats.current_juice, .3)
	tween.tween_property(juice_current_text, 'text', str(stats.current_juice), .3)


func _set_panel_location(location: Control.LayoutPreset):
	player_box.set_anchors_and_offsets_preset(location, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)

func _set_mood(value: BattleEnums.Emotions) -> void:
	_mood = value
	animated_sprite.play(BattleEnums.Emotions.keys()[value].to_lower())
	var new_mood = BattleEnums.Emotions.keys()[_mood].to_upper()
	portrait_text_emotion.texture = portrait_labels.get(value)
	portrait_back_emotion.texture = portrait_backgrounds.get(value)
	changed_mood.emit(new_mood)


func _get_mood() -> BattleEnums.Emotions:
	return _mood

static func build(preset: Control.LayoutPreset, data: PlayerData) -> PlayerPanel:
	var instance: PlayerPanel = PLAYER_PANEL.instantiate()
	instance.layout_position = preset
	instance.player_data = data
	instance.stats = data.player_stats
	instance.sprite_frames = data.sprite_frames
	return instance
