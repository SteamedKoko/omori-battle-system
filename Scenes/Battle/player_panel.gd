class_name PlayerPanel
extends Control

const PLAYER_PANEL = preload("uid://cfoptwsymul31")

@export var layout_position: Control.LayoutPreset

@onready var player_box: TextureRect = %PlayerBox
@onready var player_texture: TextureRect = %PortraitSprite

var player_data: PlayerData
var stats: Stats

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var juice_bar: TextureProgressBar = %JuiceBar
@onready var health_max_text: RichTextLabel = %HealthTextMax
@onready var health_current_text: RichTextLabel = %HealthTextCurrent
@onready var juice_max_text: RichTextLabel = %JuiceTextMax
@onready var juice_current_text: RichTextLabel = %JuiceTextCurrent


func _ready():
	_set_panel_location(layout_position)
	player_texture.texture = player_data.battle_sprites[player_data.BattleSpriteStates.NEUTRAL]

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

	# player_data.player_stats.hp

func _toasted():
	#change portrait to toast
	print('toasted')
	pass

func _took_damage(amount: int):
	#reduce hp via text and progressbar
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(health_bar, 'value', stats.current_hp, .3)
	tween.tween_property(health_current_text, 'text', str(stats.current_hp), .3)
	# health_bar.value = player_data.player_stats.current_hp
	# health_text.value = player_data.player_stats.current_hp
	pass


func _set_panel_location(location: Control.LayoutPreset):
	player_box.set_anchors_and_offsets_preset(location, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)


static func build(preset: Control.LayoutPreset, data: PlayerData) -> PlayerPanel:
	var instance: PlayerPanel = PLAYER_PANEL.instantiate()
	instance.layout_position = preset
	instance.player_data = data
	instance.stats = data.player_stats
	return instance
