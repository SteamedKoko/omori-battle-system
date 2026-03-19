class_name BattlePlayer
extends Node

var player_data: PlayerData
var player_panel: PlayerPanel

func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	player_panel = panel

func celebrate() -> void:
	if !is_alive():
		return

	player_panel.sprite_state = player_panel.SpriteStates.VICTORY

func set_random_mood() -> void:
	if !is_alive():
		return
	var emotions = player_data.emotions
	emotions.pop_front() # Remove neutral let's make this fun
	player_panel._set_mood(emotions)

func focus_player() -> void:
	player_panel.animation.play()

func unfocus_player() -> void:
	player_panel.animation.stop()

func execute_command(enemies: Array[BattleEnemy]) -> void:
	var action: BattleAction = BattleAction.new()
	action.caster = self
	action.targets = enemies
	BattleEventBus.player_action_executed.emit(action)
	player_panel.animation.stop()

func is_alive() -> bool: 
	return player_data.player_stats.current_hp > 0
