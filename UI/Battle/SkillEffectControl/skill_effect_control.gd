class_name SkillEffectControl
extends Control

const SKILL_EFFECT_CONTROL = preload("uid://b51pskhjahqax")

enum Animations {
	None,
	Rotate
}

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var skill_texture: TextureRect = %SkillTexture
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D

@export var animation_to_play: String
@export var texture_to_load: Texture2D
@export var sprite_frames: SpriteFrames

func _ready() -> void:
	if texture_to_load:
		skill_texture.texture = texture_to_load
	elif sprite_frames:
		animated_sprite.sprite_frames = sprite_frames


func play_skill_animation() -> void:
	if animation_to_play:
		animation_player.play(animation_to_play)
		await animation_player.animation_finished

	elif sprite_frames:
		animated_sprite.play()
		await animated_sprite.animation_finished

	queue_free()


static func build(skill: Skill) -> SkillEffectControl:
	var instance: SkillEffectControl = SKILL_EFFECT_CONTROL.instantiate()
	instance.texture_to_load = skill.skill_texture

	if skill.skill_animation_type != Animations.None:
		instance.animation_to_play = Animations.keys()[skill.skill_animation_type].to_lower()

	if skill.skill_sprite_frames:
		instance.sprite_frames = skill.skill_sprite_frames

	return instance
