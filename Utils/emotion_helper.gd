class_name EmotionHelper
extends Node

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
