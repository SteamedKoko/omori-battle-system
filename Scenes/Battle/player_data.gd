class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var battle_sprites: Dictionary[BattleSpriteStates, AnimatedTexture]


enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}
