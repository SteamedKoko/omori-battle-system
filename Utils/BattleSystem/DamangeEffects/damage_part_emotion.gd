class_name DamagePartEmotion
extends Resource

@export var multiplier: float = 1
## False will allow emotions of the same variant to be equal, E.G Sad == Depressed
@export var emotion_must_be_exact_match: bool = false
@export var caster_emotion: BattleEnums.Emotions

func is_match(combatant: BattleCombatant) -> bool:
	if emotion_must_be_exact_match:
		return caster_emotion == combatant.current_emotion

	return combatant.current_emotion_base_type == EmotionHelper.determine_emotion_type(caster_emotion)
