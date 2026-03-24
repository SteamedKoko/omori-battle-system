class_name EnemyData
extends Resource

@export var enemy_name: String
@export var stats: Stats
@export var sprites: Dictionary[BattleSpriteStates, AnimatedTexture]
@export var skills: Array[Skill]

enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}

var is_alive: bool:
	get: return stats.current_hp > 0
