class_name BattlePlayer
extends Node

var player_data: PlayerData
var player_panel: PlayerPanel

signal acted

func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	player_panel = panel


func act(enemies: Array[BattleEnemy]):
	print(player_data.player_name,' turn')
	player_panel.animation.play()

	# get_tree().create_timer(1).timeout.connect(func(): acted.emit())

func execute_command() -> void:
	print(player_data.player_name, ' attacked')
	acted.emit()
	player_panel.animation.stop()

func is_alive() -> bool: 
	return player_data.player_stats.current_hp > 0
