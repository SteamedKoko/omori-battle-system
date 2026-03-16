class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var battle_sprites: Dictionary[BattleSpriteStates, AnimatedTexture]
@export var skills: Array[Skill]


enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}
