class_name BattleEnemy
extends BattleCombatant

@export var enemy_data: EnemyData

var enemy_panel: EnemyPanel

func _init(data: EnemyData) -> void:
	enemy_data = data
	stats = data.stats
	enemy_panel = EnemyPanel.build(enemy_data)
	possible_emotions = enemy_data.emotions
	changed_emotion.connect(enemy_panel.change_emotion_outline)


func add_skill_animation(skill_control: SkillEffectControl) -> void:
	enemy_panel.effect_container.add_child(skill_control)


func get_action(_targets: Array) -> Command:
	var cmd: Command = AttackCommand.new(enemy_data.attack_animation)
	if enemy_data.skills.size() > 0 and randf_range(0, 100) < enemy_data.skill_use_chance:
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
		
