class_name BattlePlayer
extends Node

var player_data: PlayerData
var player_panel: PlayerPanel

func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	player_panel = panel


func focus_player() -> void:
	player_panel.animation.play()

func unfocus_player() -> void:
	player_panel.animation.stop()

func execute_command(enemies: Array[BattleEnemy]) -> void:
	print(player_data.player_name, ' attacked')
	var action: BattleAction = BattleAction.new()
	action.caster = self
	action.targets = enemies
	BattleEventBus.player_action_executed.emit(action)
	player_panel.animation.stop()

func is_alive() -> bool: 
	return player_data.player_stats.current_hp > 0
