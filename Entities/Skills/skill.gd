class_name Skill
extends Resource

enum TargetType {
	Single,
	Multi
}

enum ApplicableTarget {
	None,
	Ally,
	Enemy,
	Self,
	AllEnemy,
	AllAlly,
	All,
}

enum DebuffType {
	None,
	Defense,
	MajorDefense,
	Attack,
	MajorAttack
}


@export_subgroup("Basic")
@export var name: String
@export var description: String
@export var cost: int
@export var times_to_hit: int = 1
@export var sound: AudioStream
@export var damage_multiplyer: float = 1
@export var additional_flat_damage: float = 0

@export_subgroup("Damage Overrides")
@export var has_damage_override: bool = false
@export var damage_multiplier_override_emotion: BattleEnums.Emotions = BattleEnums.Emotions.NEUTRAL
@export var damage_multiplier_override: float = 1

@export var damage_variance: Vector2 = Vector2(.8, 1.2)

@export_subgroup("Animation")
@export var animation_kind: AnimationKind

@export_subgroup("Target")
@export var can_select_target: bool
@export var target_type: TargetType
@export var applicable_target: ApplicableTarget

@export_subgroup("Change Emotion")
@export var can_set_target_emotion: bool = false
@export var is_emotion_random: bool = false
@export var set_target_emotion: BattleEnums.Emotions
@export var can_set_caster_emotion: bool = false
@export var set_caster_emotion: BattleEnums.Emotions

@export_subgroup("Debuff")
@export var can_apply_debuff: bool = false
@export var requires_emotion_for_debuff: bool = false
@export var debuff_apply_if: BattleEnums.Emotions
@export var debuff_apply: DebuffType
