class_name BattleEnemy
extends PanelContainer

@export var stats: Stats
@export var enemy_data: EnemyData

@onready var enemy_info: EnemyInfoPanel = %EnemyInfoPanel
@onready var enemy_sprite: TextureRect = %EnemySprite
@onready var damage_container: DamageContainer = %DamageContainer

signal acted

var enemy_name: String:
	get: return enemy_data.enemy_name

const ENEMY: Resource = preload("uid://dgcegk1asy4cx")

func _ready() -> void:
	stats.took_damage.connect(got_hurt)
	damage_container.modulate = Color.TRANSPARENT

func deal_damage(amount: int) -> void:
	stats.take_damage(amount)

func got_hurt(_amount: int) -> void:
	var hurt_sprite: AnimatedTexture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.HURT)
	if hurt_sprite:
		enemy_sprite.texture = hurt_sprite

	damage_container.show_damage(_amount)
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage\n' % [enemy_data.enemy_name, _amount])
	BattleEventBus.queued_screen_shake.emit(false)

	await Engine.get_main_loop().create_timer(1).timeout

	if !is_alive():
		var tween: Tween = Engine.get_main_loop().create_tween()
		tween.tween_property(self, "position", Vector2(position.x,500), .4)
		await tween.finished
		return

	#TODO: change them back to their emotion
	enemy_sprite.texture = enemy_data.sprites.get(enemy_data.BattleSpriteStates.NEUTRAL)

		
func use_skill(skill: Skill, targets: Array[BattlePlayer]) -> void:
	BattleEventBus.sent_battle_text.emit("")
	var to_attack: Array[BattlePlayer]
	if skill.applicable_target == skill.ApplicableTarget.AllEnemy:
		to_attack.append_array(targets)
	if skill.applicable_target == skill.ApplicableTarget.Enemy:
		to_attack = [targets.pick_random()]


	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [enemy_data.enemy_name, skill.name])
	BattleEventBus.queued_sound_effect.emit(skill.sound)

	if skill.target_effect_status == skill.MoodType.Random:
		var target_index: int = 0
		for target: BattlePlayer in targets:
			var skill_control: SkillControl = SkillControl.build(skill)
			target.player_panel.effect_container.add_child(skill_control)
			if target_index == targets.size() - 1: # Only wait for the last one
				await skill_control.play_skill_animation()
			else:
				skill_control.play_skill_animation()
				target_index += 1

		for target: BattlePlayer in targets:
			target.set_random_mood()
			target.deal_damage(floor(skill.damage))

	await get_tree().create_timer(2).timeout

	acted.emit()


func attack(targets: Array[BattlePlayer]) -> void:
	var target: BattlePlayer = targets.pick_random()
	BattleEventBus.sent_battle_text.emit("")
	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [enemy_data.enemy_name, target.player_data.player_name])
	target.player_data.player_stats.take_damage(stats.attack)
	await get_tree().create_timer(1).timeout
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage' % [target.player_data.player_name, stats.attack])
	await get_tree().create_timer(1).timeout
	acted.emit()

func act(targets: Array):
	if enemy_data.skills.size() > 0:
		use_skill(enemy_data.skills[0], targets)
		return

	attack(targets)

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
