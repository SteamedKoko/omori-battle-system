class_name BattleEnemy
extends PanelContainer

@export var stats: Stats
@export var enemy_data: EnemyData

@onready var enemy_info: EnemyInfoPanel = %EnemyInfoPanel
@onready var enemy_sprite: TextureRect = %EnemySprite

signal acted

const ENEMY: Resource = preload("uid://dgcegk1asy4cx")

func _ready() -> void:
	stats.took_damage.connect(got_hurt)

func got_hurt(_amount: int) -> void:
	var hurt_sprite: AnimatedTexture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.HURT)
	if hurt_sprite:
		enemy_sprite.texture = hurt_sprite

	await Engine.get_main_loop().create_timer(.5).timeout

	if !is_alive():
		var tween: Tween = Engine.get_main_loop().create_tween()
		tween.tween_property(self, "position", Vector2(position.x,500), .4)
		await tween.finished
		return

	#TODO: change them back to their emotion
	enemy_sprite.texture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.NEUTRAL)

		

func act(targets: Array):
	var target: BattlePlayer = targets.pick_random()
	BattleEventBus.sent_battle_text.emit("")
	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [enemy_data.enemy_name, target.player_data.player_name])
	target.player_data.player_stats.take_damage(stats.attack)
	await get_tree().create_timer(1).timeout
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage' % [target.player_data.player_name, stats.attack])
	await get_tree().create_timer(1).timeout
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
