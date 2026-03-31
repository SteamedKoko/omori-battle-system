class_name EnemyData
extends Resource

@export var enemy_name: String
@export var stats: Stats
@export var sprites: Dictionary[BattleSpriteStates, AnimatedTexture]
@export var skills: Array[Skill]
@export var attack_animation: AnimationKind
@export var emotions: Array[BattleEnums.Emotions]

enum BattleSpriteStates {
	HURT,
	NEUTRAL,
}
