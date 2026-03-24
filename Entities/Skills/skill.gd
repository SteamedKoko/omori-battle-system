class_name Skill
extends Resource

enum TargetType {
	Single,
	Multi
}

enum ApplicableTarget {
	Ally,
	Enemy,
	Self,
	AllEnemy,
	AllAlly,
	All,
	None
}

enum MoodType {
	None,
	Happy,
	Sad,
	Angry,
	Scared,
	MoreHappy,
	MoreSad,
	MoreAngry,
	VeryHappy,
	VerySad,
	VeryAngry,
	Random
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
@export var damage: float
@export var sound: AudioStreamMP3
# @export var skill_animation: SpriteFrames
@export var skill_texture: Texture2D
@export var skill_animation_type: SkillEffectControl.Animations

@export_subgroup("Target")
@export var can_select_target: bool
@export var target_type: TargetType
@export var applicable_target: ApplicableTarget

@export_subgroup("Effect")
@export var target_effect_status: MoodType = MoodType.None
@export var caster_effect_status: MoodType = MoodType.None

@export_subgroup("Debuff")
@export var debuff_apply_if: MoodType
@export var debuff_apply: DebuffType

@export_subgroup("DamageMultiplyer")
@export var damage_multiplyer_if: MoodType
@export var damage_multiplyer: float = 1
