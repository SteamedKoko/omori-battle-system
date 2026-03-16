class_name BattleEnemy
extends Control

@export var stats: Stats
@export var enemy_data: EnemyData

@onready var enemy_sprite: TextureRect = %EnemySprite

signal acted
signal took_damage

const ENEMY: Resource = preload("uid://dgcegk1asy4cx")

func _ready() -> void:
	stats.took_damage.connect(got_hurt)

func got_hurt(amount: int) -> void:
	print('here we go')
	var hurt_sprite: AnimatedTexture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.HURT)
	if hurt_sprite:
		print('hurt sprite exists')
		enemy_sprite.texture = hurt_sprite
		await Engine.get_main_loop().create_timer(.5).timeout
		enemy_sprite.texture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.NEUTRAL)
		

func act(targets: Array):
	print('enemy turn')
	var target: BattlePlayer = targets.pick_random()
	print('attacking ', target.player_data.player_name)
	target.player_data.player_stats.take_damage(stats.attack)
	get_tree().create_timer(1).timeout.connect(func(): acted.emit())
	acted.emit()

func is_alive() -> bool: 
	return stats.current_hp > 0

static func build(data: EnemyData) -> BattleEnemy:
	var enemy = ENEMY.instantiate()
	enemy.stats = data.stats
	enemy.enemy_data = data
	return enemy
