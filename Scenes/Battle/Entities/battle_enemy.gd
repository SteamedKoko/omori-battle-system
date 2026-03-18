class_name BattleEnemy
extends PanelContainer

@export var stats: Stats
@export var enemy_data: EnemyData

@onready var enemy_info: EnemyInfoPanel = %EnemyInfoPanel
@onready var enemy_sprite: TextureRect = %EnemySprite
@onready var pointer_container: MarginContainer = %PointerContainer

signal acted

const ENEMY: Resource = preload("uid://dgcegk1asy4cx")

func _ready() -> void:
	stats.took_damage.connect(got_hurt)

func got_hurt(_amount: int) -> void:
	var hurt_sprite: AnimatedTexture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.HURT)
	if hurt_sprite:
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

func target_select(show_pointer: bool = true):
	enemy_info.show()
	enemy_info.toggle_pointer(show_pointer)

func target_deselect(show_pointer: bool = true):
	enemy_info.hide()
	enemy_info.toggle_pointer(show_pointer)

func is_alive() -> bool: 
	return stats.current_hp > 0

static func build(data: EnemyData) -> BattleEnemy:
	var enemy = ENEMY.instantiate()
	enemy.stats = data.stats
	enemy.enemy_data = data
	return enemy
