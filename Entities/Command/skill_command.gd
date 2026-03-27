class_name SkillCommand
extends Command

var skill: Skill

func _init(_skill: Skill) -> void:
	skill = _skill

func execute(alive_enemies: Array[BattleEnemy]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [battle_player.player_name, skill.name])

	BattleEventBus.queued_sound_effect.emit(skill.sound)
	await play_skill_animation([selected_target])

	#TODO: set mood to all targets

	#damage the targets
	for i in range(skill.times_to_hit):
		var to_attack: BattleEnemy = find_target(alive_enemies, selected_target)

		if to_attack:
			var calculated_damage: float = battle_player.battle_attack * skill.damage_multiplyer - to_attack.stats.defense
			calculated_damage *= randf_range(skill.damage_variance.x, skill.damage_variance.y)
			to_attack.take_damage(round(calculated_damage))

	await Engine.get_main_loop().create_timer(1).timeout

#This value varies depending only on the defender's emotion tier. So, for example, if the attacker is ecstatic and the defender is angry, the attack will only deal 50% more damage, while if the attacker is angry but the defender is ecstatic, the attack will deal 35% less damage.
# * Emotion Resistance: Takes 20% / 35% / 50% less damage from the weaker emotion.
# * Emotion Weakness: Deals 50% / 100% / 150% more damage to the weaker emotion.
# func get_emotion_multiplier(caster_emotion: PlayerData.Emotions, target_emotion: PlayerData.Emotions) -> float:
# 	pass

func play_skill_animation(targets: Array[BattleEnemy]) -> void:
	match skill.animation_kind.animation_target:
		AnimationKind.SkillAnimationTargets.Screen:
			var skill_control: SkillEffectControl = SkillEffectControl.build(skill.animation_kind)
			#This allows a handler to push the animation to center screen in battle manager
			BattleEventBus.queued_battle_animation.emit(skill_control)
			await skill_control.play_skill_animation()

		AnimationKind.SkillAnimationTargets.Enemy:
			var target_index: int = 0
			for _target in targets:
				var skill_control: SkillEffectControl = SkillEffectControl.build(skill.animation_kind)
				_target.player_panel.effect_container.add_child(skill_control)

				if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
					await skill_control.play_skill_animation()
				else:
					skill_control.play_skill_animation()
					target_index += 1
