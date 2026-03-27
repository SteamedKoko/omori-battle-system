class_name SkillCommand
extends Command

var skill: Skill

func _init(_skill: Skill) -> void:
	skill = _skill

func execute(alive_enemies: Array[BattleEnemy]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [battle_player.player_name, skill.name])

	BattleEventBus.queued_sound_effect.emit(skill.sound)
	await play_skill_animation([target])

	#TODO: set mood to all targets

	for i in range(skill.times_to_hit):
		var target: BattleEnemy = find_target(alive_enemies, target)

		if target:
			target.take_damage(skill.damage)

	await Engine.get_main_loop().create_timer(1).timeout


func play_skill_animation(targets: Array[BattleEnemy]) -> void:
	match skill.skill_animation_target:
		Skill.SkillAnimationTargets.Screen:
			var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
			#This allows a handler to push the animation to center screen in battle manager
			BattleEventBus.queued_battle_animation.emit(skill_control)
			await skill_control.play_skill_animation()

		Skill.SkillAnimationTargets.Enemy:
			var target_index: int = 0
			for _target in targets:
				var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
				_target.player_panel.effect_container.add_child(skill_control)

				if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
					await skill_control.play_skill_animation()
				else:
					skill_control.play_skill_animation()
					target_index += 1
