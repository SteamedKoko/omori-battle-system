class_name Command
extends RefCounted

@warning_ignore("UNUSED_SIGNAL")
signal command_executed

var selected_targets: Array[BattleCombatant]
var caster: BattleCombatant


func execute(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> void:
	pass


func find_attack_target(potential_targets: Array[BattleCombatant], current_target: BattleCombatant) -> BattleCombatant:
	if current_target and current_target.is_alive:
		return current_target

	if !potential_targets or potential_targets.size() == 0:
		return

	var alive_targets: Array[BattleCombatant] = potential_targets.filter(func(t): return t.is_alive)
	if alive_targets.size() == 0:
		return

	return alive_targets.pick_random()


class DamageCalculation:
	var base_damage: float = 0.0
	var damage_multiplier: float = 1.0
	var target_defense: float = 0.0
	var emotion_multiplier: float = 1.0
	var is_crit: bool = false # This works in tandem with crit multiplier
	var critical_multiplier: float = 1.5
	var additional_critical_damage: float = 2
	var damage_variance: Vector2 = Vector2(0.8, 1.2)

	# Crit rate
	func crunch_numbers() -> int:
		#Final Damage = {[(damage formula) * (emotion multiplier) * (critical multiplier) * (damage variance)] + additional critical damage} * (flex multiplier).
		var calculated_damage: float = base_damage * damage_multiplier 
		calculated_damage -= target_defense
		calculated_damage = max(calculated_damage, 0)
		calculated_damage *= emotion_multiplier 
		calculated_damage *= randf_range(damage_variance.x, damage_variance.y)

		if is_crit:
			calculated_damage *= critical_multiplier
			calculated_damage += additional_critical_damage

		var result: int = round(calculated_damage)
		return max(result, 0)

