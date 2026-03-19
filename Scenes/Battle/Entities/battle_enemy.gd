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

		
func use_skill(skill: Skill, targets: Array[BattlePlayer]) -> void:
	BattleEventBus.sent_battle_text.emit("")
	var to_attack: Array[BattlePlayer]
	if skill.applicable_target == skill.ApplicableTarget.AllEnemy:
		to_attack.append_array(targets)
	if skill.applicable_target == skill.ApplicableTarget.Enemy:
		to_attack = [targets.pick_random()]

	if skill.skill_animation:
		pass #play and await the animation
	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [enemy_data.enemy_name, skill.name])
	BattleEventBus.queued_audio_sample.emit(skill.sound)
	#todo finish this bad boy off
	if skill.target_effect_status == skill.MoodType.Random:
		for target in targets:
			target.set_random_mood()
			attack_single(target)
			await get_tree().create_timer(.5).timeout

	await get_tree().create_timer(1).timeout

	acted.emit()

func attack_single(target: BattlePlayer) -> void:
	target.player_data.player_stats.take_damage(stats.attack)
	await get_tree().create_timer(1).timeout
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage\n' % [target.player_data.player_name, stats.attack])
	

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
