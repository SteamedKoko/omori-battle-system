class_name EmotionHelper
extends Node

static var base_resistance_lookup: Dictionary[BattleEnums.Emotions, EmotionResistance] = {
	BattleEnums.Emotions.HAPPY: EmotionResistance.new(BattleEnums.Emotions.SAD, BattleEnums.Emotions.ANGRY),
	BattleEnums.Emotions.ANGRY: EmotionResistance.new(BattleEnums.Emotions.HAPPY, BattleEnums.Emotions.SAD),
	BattleEnums.Emotions.SAD: EmotionResistance.new(BattleEnums.Emotions.ANGRY, BattleEnums.Emotions.HAPPY),
}


static func calculate_emotion(current_emotion: BattleEnums.Emotions, incoming_emotion: BattleEnums.Emotions, possible_emotions: Array[BattleEnums.Emotions]) -> BattleEnums.Emotions:
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


static func determine_emotion_type(_emotion: BattleEnums.Emotions) -> BattleEnums.Emotions:
	# There are only 3 base types of emotions, the rest are their own thing
	match _emotion:
		BattleEnums.Emotions.ANGRY, BattleEnums.Emotions.ENRAGED, BattleEnums.Emotions.FURIOUS:
			return BattleEnums.Emotions.ANGRY
		BattleEnums.Emotions.HAPPY, BattleEnums.Emotions.ECSTATIC, BattleEnums.Emotions.MANIC:
			return BattleEnums.Emotions.HAPPY
		BattleEnums.Emotions.SAD, BattleEnums.Emotions.DEPRESSED, BattleEnums.Emotions.MISERABLE:
			return BattleEnums.Emotions.SAD
		_: return _emotion


#This value varies depending only on the defender's emotion tier. So, for example, if the attacker is ecstatic and the defender is angry, the attack will only deal 50% more damage, while if the attacker is angry but the defender is ecstatic, the attack will deal 35% less damage.
# * Emotion Resistance: Takes 20% / 35% / 50% less damage from the weaker emotion.
# * Emotion Weakness: Deals 50% / 100% / 150% more damage to the weaker emotion.
static func get_emotion_multiplier(caster_emotion: BattleEnums.Emotions, target_emotion: BattleEnums.Emotions) -> float:
	var core_caster_emotion: BattleEnums.Emotions = EmotionHelper.determine_emotion_type(caster_emotion)
	var core_target_emotion: BattleEnums.Emotions = EmotionHelper.determine_emotion_type(target_emotion)

	var weakness_values: Array[float] = [1.5, 2, 2.5]
	var resistance_values: Array[float] = [0.8, 0.65, 0.5]

	var resistance: EmotionResistance = base_resistance_lookup.get(core_target_emotion)

	if !resistance:
		return 1

	if resistance.weakness_emotion == core_caster_emotion:
		return weakness_values[target_emotion - core_target_emotion]

	if resistance.strength_emotion == core_caster_emotion:
		return resistance_values[target_emotion - core_target_emotion]

	return 1


class EmotionResistance:
	var weakness_emotion: BattleEnums.Emotions
	var strength_emotion: BattleEnums.Emotions

	func _init(weakness: BattleEnums.Emotions, strength: BattleEnums.Emotions) -> void:
		weakness_emotion = weakness
		strength_emotion = strength
