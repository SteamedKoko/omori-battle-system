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
var texture_to_load: Texture2D

func _ready() -> void:
	if texture_to_load:
		skill_texture.texture = texture_to_load


func play_skill_animation() -> void:
	if animation_to_play:
		animation_player.play(animation_to_play)
		await animation_player.animation_finished

	queue_free()

static func build(skill: Skill) -> SkillControl:
	var instance: SkillControl = SKILL_CONTROL.instantiate()
	instance.texture_to_load = skill.skill_texture

	if skill.skill_animation_type != Animations.None:
		instance.animation_to_play = Animations.keys()[skill.skill_animation_type].to_lower()
	
	return instance
