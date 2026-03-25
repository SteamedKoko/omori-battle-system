class_name BattlePlayer
extends RefCounted

signal finished_taking_damage

var player_data: PlayerData
var player_panel: PlayerPanel

var player_name: String:
	get: return player_data.player_name

var is_alive: bool:
	get: return player_data.player_stats.is_alive

func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	player_panel = panel
	player_panel.stats.took_damage.connect(_take_damage)

func take_damage(damage_to_deliver: int) -> void:
	player_data.player_stats.take_damage(damage_to_deliver)
	
func _take_damage(damage_taken: int) -> void:
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage\n' % [player_data.player_name, damage_taken])
	BattleEventBus.queued_screen_shake.emit(false)
	await player_panel.damage_container.show_damage(damage_taken)
	finished_taking_damage.emit()

func celebrate() -> void:
	if !is_alive:
		return

	player_panel.sprite_state = player_panel.SpriteStates.VICTORY

func set_emotion(new_emotion: PlayerData.Emotions) -> void:
	if !is_alive:
		return

	player_panel.mood = new_emotion

func set_random_mood() -> void:
	if !is_alive:
		return

	var emotions = player_data.emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	player_panel.mood = emotions.pick_random()


func focus_player() -> void:
	player_panel.animation.play()


func unfocus_player() -> void:
	player_panel.animation.stop()
