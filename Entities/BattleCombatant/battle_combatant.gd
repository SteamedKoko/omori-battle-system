class_name BattleCombatant
extends RefCounted

signal changed_emotion(emotion: BattleEnums.Emotions)

var possible_emotions: Array[BattleEnums.Emotions] = []

var stats: Stats
var current_emotion: BattleEnums.Emotions

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

	current_emotion = calculate_emotion(new_emotion)
	changed_emotion.emit(current_emotion)

func calculate_emotion(incoming_emotion: BattleEnums.Emotions) -> BattleEnums.Emotions:

	var current_type: BattleEnums.Emotions = determine_emotion_type(current_emotion)
	var incoming_type: BattleEnums.Emotions = determine_emotion_type(incoming_emotion)

	var elevating_types: Array[BattleEnums.Emotions] = [BattleEnums.Emotions.ANGRY, BattleEnums.Emotions.HAPPY, BattleEnums.Emotions.SAD]

	# # Return early with incoming on anything that isn't the main 3 emotion types
	if !elevating_types.has(incoming_type):
		return incoming_emotion

	# If the emotion is of a different base emotion, then we just swap over to the new one E.G Furious -> Depressed, Happy -> Neutral
	if current_type != incoming_type:
		return incoming_emotion

	# Now we only have same type emotions left, if they are final stage just return them
	if [BattleEnums.Emotions.FURIOUS, BattleEnums.Emotions.MISERABLE, BattleEnums.Emotions.MANIC].has(current_emotion):
		return current_emotion

	# Only emotions left are of the same type and progressable, try to increment current emotion and return it if the combatant has the emotion
	var new_emotion: BattleEnums.Emotions = (current_emotion + 1) as BattleEnums.Emotions
	if possible_emotions.has(new_emotion):
		return new_emotion

	return current_emotion


func determine_emotion_type(_emotion: BattleEnums.Emotions) -> BattleEnums.Emotions:
	# There are only 3 base types of emotions, the rest are their own thing
	match _emotion:
		BattleEnums.Emotions.ANGRY, BattleEnums.Emotions.ENRAGED, BattleEnums.Emotions.FURIOUS:
			return BattleEnums.Emotions.ANGRY
		BattleEnums.Emotions.HAPPY, BattleEnums.Emotions.ECSTATIC, BattleEnums.Emotions.MANIC:
			return BattleEnums.Emotions.HAPPY
		BattleEnums.Emotions.SAD, BattleEnums.Emotions.DEPRESSED, BattleEnums.Emotions.MISERABLE:
			return BattleEnums.Emotions.SAD
		_: return _emotion



func set_random_emotion() -> void:
	if !is_alive:
		return

	var emotions: Array[BattleEnums.Emotions] = possible_emotions.duplicate()
	emotions.pop_front() # Remove neutral let's make this fun
	set_emotion(emotions.pick_random())

func add_skill_animation(_skill_control: SkillEffectControl) -> void:
	pass
