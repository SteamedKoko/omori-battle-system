class_name SkillCommand
extends Command

var skill: Skill

func _init(_skill: Skill) -> void:
	skill = _skill

func execute(alive_enemies: Array[BattleEnemy]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [battle_player.player_name, skill.name])
	BattleEventBus.queued_sound_effect.emit(skill.sound)

	await play_skill_animation(targets)

	# for i in range(skill.times_to_hit):
	# 	var target = find_target(alive_enemies, targets)

	await Engine.get_main_loop().create_timer(1).timeout


func play_skill_animation(targets: Array[BattleEnemy]) -> void:
	match skill.skill_animation_target:
		Skill.SkillAnimationTargets.Screen:
			var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
			#TODO: need to add this as a child somewhere
			BattleEventBus.queued_battle_animation.emit(skill_control)
			print('playing anim')
			await skill_control.play_skill_animation()
			# await skill_control.animation_player.animation_finished

		Skill.SkillAnimationTargets.Enemy:
			var target_index: int = 0
			for target in targets:
				var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
				target.player_panel.effect_container.add_child(skill_control)

				if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
					await skill_control.play_skill_animation()
				else:
					skill_control.play_skill_animation()
					target_index += 1
