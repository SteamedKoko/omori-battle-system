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
## Handles the animation and sound effect for the skill
@export var animation_kind: AnimationKind
## Handles damage and healing for the skill
@export var damage_effects: Array[BaseDamageEffect]


@export_subgroup("Target")
## Leaving this false will result in spells hitting a random ally or enemy if ApplicableTarget is set to enemy or ally
@export var can_select_target: bool
## Any possible targets for skill, will fallback on another target if enemy is dead and set to enemy
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
