class_name EnemyPanel
extends PanelContainer

@onready var enemy_info: EnemyInfoPanel = %EnemyInfoPanel
@onready var enemy_sprite: TextureRect = %EnemySprite
@onready var damage_container: DamageContainer = %DamageContainer
@onready var effect_container: Control = %EffectContainer

@export var enemy_data: EnemyData

const ENEMY_PANEL = preload("uid://dgcegk1asy4cx")

static func build(data: EnemyData) -> EnemyPanel:
	var panel: EnemyPanel = ENEMY_PANEL.instantiate()
	panel.enemy_data = data
	return panel


func _ready() -> void:
	enemy_info.enemy_data = enemy_data
	enemy_data.stats.took_damage.connect(got_hurt)
	damage_container.modulate = Color.TRANSPARENT

func target_select(show_pointer: bool = true):
	enemy_info.show()
	enemy_info.toggle_pointer(show_pointer)

func target_deselect(show_pointer: bool = true):
	enemy_info.hide()
	enemy_info.toggle_pointer(show_pointer)

func got_hurt(_amount: int) -> void:
	var hurt_sprite: AnimatedTexture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.HURT)
	if hurt_sprite:
		enemy_sprite.texture = hurt_sprite

	damage_container.show_damage(_amount)
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage\n' % [enemy_data.enemy_name, _amount])
	BattleEventBus.queued_screen_shake.emit(false)

	await Engine.get_main_loop().create_timer(1).timeout

	if !enemy_data.stats.is_alive:
		await _play_death_animation()
		return

	#TODO: change them back to their emotion
	enemy_sprite.texture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.NEUTRAL)

func _play_death_animation() -> void:
	var tween: Tween = Engine.get_main_loop().create_tween()
	tween.tween_property(self, "position", Vector2(position.x,500), .4)
	await tween.finished
