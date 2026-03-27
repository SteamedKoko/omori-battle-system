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

enum MoodType {
	None,
	Neutral,
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

enum SkillAnimationTargets {
	None,
	Self,
	Enemy,
	Screen
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
@export var damage_multiplier_override_emotion: PlayerData.Emotions = PlayerData.Emotions.NEUTRAL
@export var damage_multiplier_override: float = 1

@export var damage_variance: Vector2 = Vector2(.8, 1.2)

@export_subgroup("Animation")
@export var skill_texture: Texture2D
@export var skill_sprite_frames: SpriteFrames
@export var skill_animation_target: SkillAnimationTargets
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

