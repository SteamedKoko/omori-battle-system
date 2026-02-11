class_name PlayerData
extends Resource

@export var player_name: String
@export var player_stats: Stats
@export var battle_sprites: Dictionary[BattleSpriteStates, AnimatedTexture]

signal took_damage
signal healed_health
signal revived

enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}
