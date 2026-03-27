class_name Command
extends RefCounted

@warning_ignore("UNUSED_SIGNAL")
signal command_executed

var selected_target: BattleCombatant
var selected_targets: Array[BattleCombatant]
var caster: BattleCombatant


func execute(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> void:
	pass


func find_attack_target(potential_targets: Array[BattleCombatant], current_target: BattleCombatant) -> BattleCombatant:
	if current_target and current_target.is_alive:
		return current_target

	var alive_targets: Array[BattleCombatant] = potential_targets.filter(func(t): return t.is_alive)
	if alive_targets.size() == 0:
		return

	return potential_targets.pick_random()
