class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var sprite_frames: SpriteFrames
@export var skills: Array[Skill]


enum BattleSpriteStates {
	NORMAL,
	HURT,
	TOAST,
	HAPPY,
	SAD,
	ANGRY
}
