class_name EnemyData
extends Resource

@export var enemy_name: String
@export var stats: Stats
@export var sprites: Dictionary[BattleSpriteStates, AnimatedTexture]
@export var skills: Array[Skill]
@export var crit_sound: AudioStream = preload("uid://ddv25jmf3hyke")
@export var attack_animation: AnimationKind
@export var emotions: Array[BattleEnums.Emotions]
@export var skill_use_chance: float = 30

enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}
