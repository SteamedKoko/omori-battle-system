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
	get: return stats.attack * EmotionHelper.get_base_stat_multiplier(BattleEnums.StatType.Attack, current_emotion)
var battle_luck: float:
	get: return stats.luck * EmotionHelper.get_base_stat_multiplier(BattleEnums.StatType.Luck, current_emotion)
var battle_speed: float:
	get: return stats.speed * EmotionHelper.get_base_stat_multiplier(BattleEnums.StatType.Speed, current_emotion)
var battle_defense: float:
	get: return stats.defense * EmotionHelper.get_base_stat_multiplier(BattleEnums.StatType.Defense, current_emotion)
var battle_hit: float:
	get: return stats.hit * EmotionHelper.get_base_stat_multiplier(BattleEnums.StatType.Hit, current_emotion)

var is_alive: bool:
	get: return stats.is_alive


func get_combatant_name() -> String:
	return ""

func take_damage(damage_to_deliver: int) -> void:
	#TODO: If sad split some damage out for juice too
	stats.take_damage(damage_to_deliver)


func heal_damage(amount_to_heal: int) -> void:
	stats.heal_damage(amount_to_heal)


func set_emotion(new_emotion: BattleEnums.Emotions) -> void:
	if !is_alive:
		return

	current_emotion = EmotionHelper.calculate_emotion(current_emotion, new_emotion, possible_emotions)
	changed_emotion.emit(current_emotion)
	return


func set_random_emotion() -> void:
	if !is_alive:
		return

	var emotions: Array[BattleEnums.Emotions] = possible_emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	set_emotion(emotions.pick_random())


func add_skill_animation(_skill_control: SkillEffectControl) -> void:
	pass
