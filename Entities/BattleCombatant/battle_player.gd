class_name BattlePlayer
extends BattleCombatant

signal finished_taking_damage

var player_data: PlayerData
var player_panel: PlayerPanel


func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	stats = data.player_stats
	player_panel = panel
	player_panel.stats.took_damage.connect(_on_take_damage)

func get_combatant_name() -> String:
	return player_data.player_name


func _on_take_damage(damage_taken: int) -> void:
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage\n' % [player_data.player_name, damage_taken])
	BattleEventBus.queued_screen_shake.emit(false)
	await player_panel.damage_container.show_damage(damage_taken)
	finished_taking_damage.emit()

func celebrate() -> void:
	if !is_alive:
		return

	player_panel.sprite_state = player_panel.SpriteStates.VICTORY

func set_emotion(new_emotion: BattleEnums.Emotions) -> void:
	if !is_alive:
		return

	player_panel.mood = new_emotion

func set_random_mood() -> void:
	if !is_alive:
		return

	var emotions = player_data.emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	set_emotion(emotions.pick_random())


func focus_player() -> void:
	player_panel.animation.play()


func unfocus_player() -> void:
	player_panel.animation.stop()
