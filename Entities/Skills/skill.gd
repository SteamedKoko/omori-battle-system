class_name Skill
extends Resource

#TBH inheritance will shine here to have AttackSkill or HealSkill or ETCSkill
enum SkillTypes {
	Attack,
	Support,
}


@export_subgroup("Basic")
@export var name: String
@export var description: String
@export var skill_type: SkillTypes = SkillTypes.Attack
@export var cost: int
@export var times_to_hit: int = 1
@export var animation_kind: AnimationKind
@export var damage_effects: Array[BaseDamageEffect]


@export_subgroup("Target")
@export var can_select_target: bool
@export var applicable_target: BattleEnums.ApplicableTarget

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
@export var debuff_apply: BattleEnums.DebuffType
