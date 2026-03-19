class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var sprite_frames: SpriteFrames
@export var skills: Array[Skill]
@export var emotions: Array[Emotions]


enum Emotions {
	NEUTRAL,
	HAPPY,
	ECSTATIC,
	MANIC,
	SAD,
	DEPRESSED,
	MISERABLE,
	ANGRY,
	ENRAGED,
	FURIOUS,
	SPAMTON,
}

enum BattleSpriteStates {
	HURT,
	VICTORY,
	TOAST,
	SUCCUMB,
	DEFEATED,
}
