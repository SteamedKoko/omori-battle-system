class_name SkillControl
extends Control

const SKILL_CONTROL = preload("uid://ch283vo3qf5qx")

enum Animations {
	None,
	Rotate
}

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skill_texture: TextureRect = %SkillTexture

var animation_to_play: String

func play_skill_animation() -> void:
	if animation_to_play:
		animation_player.play(animation_to_play)
		await animation_player.animation_finished
		return


static func build(texture: Texture2D, animation: Animations) -> void:
	var instance: SkillControl = SKILL_CONTROL.instantiate()
	instance.skill_texture.texture = texture

	if animation != Animations.None:
		instance.animation_to_play = Animations.keys()[animation].to_lower()
