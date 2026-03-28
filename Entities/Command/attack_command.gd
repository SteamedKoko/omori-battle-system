class_name AttackCommand
extends Command

func execute(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> void:
	BattleEventBus.sent_battle_text.emit('')
	var initial_damage: float = caster.battle_attack

	await Engine.get_main_loop().create_timer(1).timeout

	#calculations all happen here

	var current_target: BattleCombatant
	if selected_targets.size() > 0:
			current_target = selected_targets[0]

	var to_attack: BattleCombatant = find_attack_target(_possible_enemy_targets, current_target)
	if !to_attack:
		command_executed.emit()
		return

	# TODO: Bro maybe we need to do more here based on emotions etc
	var damage_to_deal: float = (initial_damage * 2) * randf_range(.8, 1.2)
	damage_to_deal -= to_attack.stats.defense

	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [ caster.get_combatant_name(), to_attack.get_combatant_name() ])
	await Engine.get_main_loop().create_timer(1).timeout
	to_attack.take_damage(round(damage_to_deal))

	await Engine.get_main_loop().create_timer(1).timeout
	command_executed.emit()
