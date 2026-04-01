class_name AttackEffect
extends BaseDamageEffect

## All damage parts will be added together
@export var damage_parts: Array[DamagePart]
## Will pick a number randomly in this range to give damage variety
@export var damage_variance: Vector2 = Vector2(0.8, 1.2)
## Amount of damage to be multiplied if a critical occurs
@export var critical_multiplier: float = 1.5
## Extra beef on crits for good measure + this value
@export var additional_critical_damage: float = 2

func execute(caster: BattleCombatant ,target: BattleCombatant, is_crit: bool = false) -> void:
	var calculated_damage: float = _get_base_damage(caster)
	calculated_damage -= target.battle_defense
	if calculated_damage <= 0:
		target.take_damage(0)
		return 

	calculated_damage *= EmotionHelper.get_emotion_multiplier(caster.current_emotion, target.current_emotion)
	calculated_damage *= randf_range(damage_variance.x, damage_variance.y)

	if is_crit:
		calculated_damage *= critical_multiplier
		calculated_damage += additional_critical_damage

	var result: int = round(calculated_damage)
	result = max(result, 0)

	target.take_damage(result)

func _get_base_damage(combatant: BattleCombatant) -> float:
	var total_base_damage: float = 0.0
	for part: DamagePart in damage_parts:
		total_base_damage += part.get_total(combatant)

	return total_base_damage
		
