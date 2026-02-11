class_name PlayerPanel
extends Control

const PLAYER_PANEL = preload("uid://cfoptwsymul31")

@export var layout_position: Control.LayoutPreset

@onready var player_box: TextureRect = %PlayerBox
@onready var player_texture: TextureRect = %PortraitSprite

var player_data: PlayerData

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var juice_bar: TextureProgressBar = %JuiceBar
@onready var health_text: RichTextLabel = %HealthText
@onready var juice_text: RichTextLabel = %JuiceText


func _ready():
	_set_panel_location(layout_position)
	player_texture.texture = player_data.battle_sprites[player_data.BattleSpriteStates.NEUTRAL]

	health_bar.max_value = player_data.player_stats.max_hp
	juice_bar.max_value = player_data.player_stats.max_juice
	health_bar.value = player_data.player_stats.current_hp
	juice_bar.value = player_data.player_stats.current_juice

	health_text.text = str(player_data.player_stats.current_hp) + '/' + str(player_data.player_stats.max_hp)
	juice_text.text = str(player_data.player_stats.current_juice) + '/' + str(player_data.player_stats.max_juice)

	# player_data.player_stats.hp


func _set_panel_location(location: Control.LayoutPreset):
	player_box.set_anchors_and_offsets_preset(location, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)


static func build(preset: Control.LayoutPreset, data: PlayerData) -> PlayerPanel:
	var instance: PlayerPanel = PLAYER_PANEL.instantiate()
	instance.layout_position = preset
	instance.player_data = data
	return instance
