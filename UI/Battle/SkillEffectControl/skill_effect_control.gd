@tool
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
@onready var audio_player: AudioStreamPlayer2D = %AudioStreamPlayer2D

@export var animation_to_play: String
@export var texture_to_load: Texture2D
@export var sprite_frames: SpriteFrames
@export var audio_to_play: AudioStream

@export var playing: bool

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and playing:
		playing = false
		play_skill_animation()

func play_skill_animation() -> void:
	if audio_to_play:
		audio_player.stream = audio_to_play

	if texture_to_load:
		skill_texture.texture = texture_to_load
		audio_player.play()
		skill_texture.show()
		animation_player.play(animation_to_play)
		await animation_player.animation_finished
		skill_texture.texture = null

	elif sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.show()
		animated_sprite.play()
		audio_player.play()
		await animated_sprite.animation_finished
		animated_sprite.sprite_frames = null

	audio_player.stream = null

	queue_free()


static func build(skill: Skill) -> SkillEffectControl:
	var instance: SkillEffectControl = SKILL_EFFECT_CONTROL.instantiate()
	instance.texture_to_load = skill.skill_texture
	instance.sprite_frames = skill.skill_sprite_frames
	instance.audio_to_play = skill.sound

	if skill.skill_animation_type != Animations.None:
		instance.animation_to_play = Animations.keys()[skill.skill_animation_type].to_lower()

	return instance
