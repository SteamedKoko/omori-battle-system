class_name BattleEnemy
extends BattleCombatant

@export var enemy_data: EnemyData

var enemy_panel: EnemyPanel

func _init(data: EnemyData) -> void:
	enemy_data = data
	stats = data.stats
	enemy_panel = EnemyPanel.build(enemy_data)

func add_skill_animation(skill_control: SkillEffectControl) -> void:
	enemy_panel.effect_container.add_child(skill_control)


func get_action(_targets: Array) -> Command:
	BattleEventBus.sent_battle_text.emit("")
	var cmd: Command = AttackCommand.new()
	if enemy_data.skills.size() > 0:
		cmd = SkillCommand.new(enemy_data.skills[0], self)

	cmd.caster = self
	return cmd


func get_combatant_name() -> String:
	return enemy_data.enemy_name


func take_damage(amount: int) -> void:
	stats.take_damage(amount)


func target_select(show_pointer: bool = true) -> void:
	enemy_panel.target_select(show_pointer)


func target_deselect(show_pointer: bool = true) -> void:
	enemy_panel.target_deselect(show_pointer)
		

func _determine_targets(applicable_target: Skill.ApplicableTarget ,targets: Array[BattlePlayer]) -> Array[BattlePlayer]:
	var to_attack: Array[BattlePlayer]
	match applicable_target:
		Skill.ApplicableTarget.AllEnemy: return targets
		Skill.ApplicableTarget.Enemy: return [targets.pick_random()]

	return to_attack
			

func _damage_targets(damage_to_deal: float, targets: Array[BattlePlayer]) -> void:
	for target: BattlePlayer in targets:
		target.take_damage( floor(damage_to_deal))


func _play_skill_animation_on_targets(skill: Skill, targets: Array[BattlePlayer]) -> void:
	var target_index: int = 0
	for target: BattlePlayer in targets:
		var skill_control: SkillEffectControl = SkillEffectControl.build(skill.animation_kind)
		target.player_panel.effect_container.add_child(skill_control)

		if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
			await skill_control.play_skill_animation()
		else:
			skill_control.play_skill_animation()
			target_index += 1
	
