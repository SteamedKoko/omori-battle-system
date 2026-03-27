class_name BattleCombatant
extends RefCounted

var stats: Stats
var current_emotion: BattleEnums.Emotions
var battle_attack: float:
	get: return stats.attack #Do additional modificatio

var is_alive: bool:
	get: return stats.is_alive

func get_combatant_name() -> String:
	return ""

func take_damage(damage_to_deliver: int) -> void:
	stats.take_damage(damage_to_deliver)
