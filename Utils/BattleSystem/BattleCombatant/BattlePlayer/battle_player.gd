class_name BattlePlayer
extends BattleCombatant

signal finished_taking_damage

var player_data: PlayerData
var player_panel: PlayerPanel

func _init(data: PlayerData, panel: PlayerPanel) -> void:
	player_data = data
	stats = data.player_stats
	player_panel = panel
	possible_emotions = player_data.emotions.duplicate()
	crit_sound = player_data.crit_sound
	changed_emotion.connect(_on_changed_emotion)
	stats.took_damage.connect(_on_take_damage)
	stats.healed_damage.connect(_on_heal_damage)


func get_combatant_name() -> String:
	return player_data.player_name


func _on_take_damage(damage_taken: int) -> void:
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage' % [player_data.player_name, damage_taken])
	BattleEventBus.queued_screen_shake.emit(false)
	await player_panel.damage_container.show_damage(damage_taken)
	finished_taking_damage.emit()

func _on_heal_damage(amount: int) -> void:
	BattleEventBus.sent_battle_text_append.emit("%s healed %s damage" % [player_data.player_name, amount])
	await player_panel.damage_container.show_heal(amount)


func celebrate() -> void:
	if !is_alive:
		return

	player_panel.mood = BattleEnums.Emotions.NEUTRAL
	player_panel.player_state = PlayerPanel.PlayerStates.VICTORY


func _on_changed_emotion(new_emotion: BattleEnums.Emotions) -> void:
	player_panel.mood = new_emotion


func focus_player() -> void:
	player_panel.animation.play()


func unfocus_player() -> void:
	player_panel.animation.stop()


func add_skill_animation(skill_control: SkillEffectControl) -> void:
	player_panel.effect_container.add_child(skill_control)
