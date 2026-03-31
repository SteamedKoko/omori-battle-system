class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var sprite_frames: SpriteFrames
@export var attack_animation: AnimationKind
@export var crit_sound: AudioStream = preload("uid://ddv25jmf3hyke")
@export var skills: Array[Skill]
@export var emotions: Array[BattleEnums.Emotions]

enum BattleSpriteStates {
	HURT,
	VICTORY,
	TOAST,
	SUCCUMB,
	DEFEATED,
}
