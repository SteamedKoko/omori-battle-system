class_name BattleCombatant
extends RefCounted

signal changed_emotion(emotion: BattleEnums.Emotions)

var possible_emotions: Array[BattleEnums.Emotions] = []
var crit_sound: AudioStream

var stats: Stats
var current_emotion: BattleEnums.Emotions
var current_emotion_base_type: BattleEnums.Emotions:
	get: return EmotionHelper.determine_emotion_type(current_emotion)

 #Do additional modifications, buffs, etc
var battle_attack: float:
	get: return stats.attack
var battle_luck: float:
	get: return stats.luck
var battle_speed: float:
	get: return stats.speed
var battle_defense: float:
	get: return stats.defense

var is_alive: bool:
	get: return stats.is_alive

func get_combatant_name() -> String:
	return ""

func take_damage(damage_to_deliver: int) -> void:
	stats.take_damage(damage_to_deliver)

func set_emotion(new_emotion: BattleEnums.Emotions) -> void:
	if !is_alive:
		return

	current_emotion = EmotionHelper.calculate_emotion(current_emotion, new_emotion, possible_emotions)
	changed_emotion.emit(current_emotion)


func set_random_emotion() -> void:
	if !is_alive:
		return

	var emotions: Array[BattleEnums.Emotions] = possible_emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	set_emotion(emotions.pick_random())

func add_skill_animation(_skill_control: SkillEffectControl) -> void:
	pass
