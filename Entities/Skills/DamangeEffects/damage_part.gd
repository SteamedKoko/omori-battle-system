class_name DamagePart
extends Resource

## These stats will be added before being multiplied
@export var additive_stats: Array[BattleEnums.StatType] = [BattleEnums.StatType.Attack]
@export var multiplier: float = 1

## Multiplier specified here will have priority if caster emotion matches
@export var damage_part_emotion: DamagePartEmotion

func get_total(combatant: BattleCombatant) -> float:
	var total: float = 0
	for stat: BattleEnums.StatType in additive_stats:
		total += _get_base_stat(combatant, stat)

	if damage_part_emotion and damage_part_emotion.is_match(combatant):
		return total * damage_part_emotion.multiplier
			
	return total * multiplier

	
func _get_base_stat(combatant: BattleCombatant, base_stat_type: BattleEnums.StatType) -> float:
	match base_stat_type:
		BattleEnums.StatType.Attack: return combatant.battle_attack
		BattleEnums.StatType.Luck: return combatant.battle_luck
		BattleEnums.StatType.Speed: return combatant.battle_speed
		BattleEnums.StatType.Defense: return combatant.battle_defense
		_: return 0
