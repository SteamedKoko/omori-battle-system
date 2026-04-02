class_name HealEffect
extends BaseDamageEffect

## Will pick a number randomly in this range to heal amount variety
@export var heal_variance: Vector2 = Vector2(0.8, 1.2)

func execute(caster: BattleCombatant, target: BattleCombatant, is_crit: bool = false) -> void:
	var calculated_heal: float = _get_base_damage(target)

	var result: int = max(round(calculated_heal), 0)
	#TODO: figure out revives
	if target.is_alive:
		target.heal_damage(result)
