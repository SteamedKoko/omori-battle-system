class_name BattlePlayer
extends Node

var player_data: PlayerData

signal acted

func _init(data: PlayerData) -> void:
	player_data = data

# func build() -> BattlePlayer:


func act(enemies: Array[BattleEnemy]):
	print(player_data.player_name,' turn')
	get_tree().create_timer(1).timeout.connect(func(): acted.emit())

func is_alive() -> bool: 
	return player_data.player_stats.current_hp > 0
