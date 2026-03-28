class_name BattleCombatant
extends RefCounted

signal changed_emotion(emotion: BattleEnums.Emotions)

var possible_emotions: Array[BattleEnums.Emotions] = []

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

func set_emotion(new_emotion: BattleEnums.Emotions) -> void:
	if !is_alive:
		return

	current_emotion = new_emotion
	changed_emotion.emit(new_emotion)

func set_random_emotion() -> void:
	if !is_alive:
		return

	var emotions: Array[BattleEnums.Emotions] = possible_emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	set_emotion(emotions.pick_random())
