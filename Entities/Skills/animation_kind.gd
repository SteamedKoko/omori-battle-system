class_name AnimationKind
extends Resource

@export var animation_target: SkillAnimationTargets
@export var adhoc_animation: AdhocAnimations
@export var animation_audio: AudioStream

enum AdhocAnimations {
	None,
	Rotate
}

enum SkillAnimationTargets {
	None,
	Self,
	Enemy,
	Screen
}
