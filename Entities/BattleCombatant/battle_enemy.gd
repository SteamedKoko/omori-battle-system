class_name BattleEnemy
extends RefCounted

signal acted

@export var stats: Stats
@export var enemy_data: EnemyData

var enemy_panel: EnemyPanel

var enemy_name: String:
	get: return enemy_data.enemy_name

var is_alive: bool:
	get: return enemy_data.is_alive

func _init(data: EnemyData) -> void:
	enemy_data = data
	stats = data.stats
	enemy_panel = EnemyPanel.build(enemy_data)

func take_damage(amount: int) -> void:
	stats.take_damage(amount)

func target_select(show_pointer: bool = true) -> void:
	enemy_panel.target_select(show_pointer)

func target_deselect(show_pointer: bool = true) -> void:
	enemy_panel.target_deselect(show_pointer)
		
#TBH I could use the commands like the players do and have all combatants
# have the same parent class and execute commands, but that'll take more work. 
# I leave this task to any future person that wants to work on it
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
			var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
			target.player_panel.effect_container.add_child(skill_control)
			if target_index == targets.size() - 1: # Only wait for the last one
				await skill_control.play_skill_animation()
			else:
				skill_control.play_skill_animation()
				target_index += 1

		for target: BattlePlayer in targets:
			target.set_random_mood()
			target.deal_damage(floor(skill.damage))

	await Engine.get_main_loop().create_timer(2).timeout

	acted.emit()


func attack(targets: Array[BattlePlayer]) -> void:
	var target: BattlePlayer = targets.pick_random()
	BattleEventBus.sent_battle_text.emit("")
	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [enemy_data.enemy_name, target.player_data.player_name])
	target.player_data.player_stats.take_damage(stats.attack)
	await Engine.get_main_loop().create_timer(1).timeout
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage' % [target.player_data.player_name, stats.attack])
	await Engine.get_main_loop().create_timer(1).timeout
	acted.emit()

func act(targets: Array):
	if enemy_data.skills.size() > 0:
		use_skill(enemy_data.skills[0], targets)
		return

	attack(targets)
