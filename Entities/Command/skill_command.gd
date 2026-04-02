class_name SkillCommand
extends Command

var skill: Skill

func _init(_skill: Skill, _caster: BattleCombatant) -> void:
	skill = _skill
	caster = _caster

func execute(_possible_enemies: Array[BattleCombatant], _possible_allies: Array[BattleCombatant]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	caster.stats.lose_juice(skill.cost)
	await Engine.get_main_loop().create_timer(1).timeout

	match skill.skill_type:
		Skill.SkillTypes.Attack: await execute_attack_skill(_possible_enemies, _possible_allies)
		Skill.SkillTypes.Support: await execute_support_skill(_possible_enemies, _possible_allies)


	if skill.can_set_caster_emotion:
		caster.set_emotion(skill.set_caster_emotion)

	await Engine.get_main_loop().create_timer(1).timeout
	command_executed.emit()

# Man this is all so messy I hate it
func execute_support_skill(_possible_enemies: Array[BattleCombatant], _possible_allies: Array[BattleCombatant]) -> void:

	BattleEventBus.sent_battle_text.emit("%s performs %s" % [caster.get_combatant_name(), skill.name])
	await play_skill_animation(selected_targets)

	#TODO: need revive to actually get through this
	if selected_targets.size() == 1:
		if !selected_targets[0].is_alive:
			BattleEventBus.sent_battle_text_append.emit("It did nothing!")

	for target: BattleCombatant in selected_targets:
		for effect: BaseDamageEffect in skill.damage_effects:
			effect.execute(caster, target, false)

		if skill.can_set_target_emotion:
			if skill.is_emotion_random:
				target.set_random_emotion()
			else:
				target.set_emotion(skill.set_target_emotion)


func execute_attack_skill(_possible_enemies: Array[BattleCombatant], _possible_allies: Array[BattleCombatant]) -> void:
	var alive_targets: Array[BattleCombatant] = determine_targets(_possible_enemies, _possible_allies)
	if alive_targets.size() == 0:
		command_executed.emit()
		return

	BattleEventBus.sent_battle_text.emit("%s performs %s" % [caster.get_combatant_name(), skill.name])

	var is_crit: bool = randf_range(0, 100) < caster.battle_luck

	await play_skill_animation(alive_targets)

	#damage the targets
	for i in range(skill.times_to_hit):
		for current_target: BattleCombatant in alive_targets:
			var to_attack: BattleCombatant = find_attack_target(alive_targets, current_target)
			if !to_attack:
				break
			# attack_target(to_attack)
			for effect: BaseDamageEffect in skill.damage_effects:
				effect.execute(caster, to_attack, is_crit)

			if skill.can_set_target_emotion:
				if skill.is_emotion_random:
					current_target.set_random_emotion()
				else:
					current_target.set_emotion(skill.set_target_emotion)

		alive_targets = determine_targets(_possible_enemies, _possible_allies)
		is_crit = randf_range(0, 100) < caster.battle_luck #reroll crit luck if second attack

# This is actually overkill, the game targets dead allies and does nothing, so should only be focus for enemies
func determine_targets(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> Array[BattleCombatant]:
	var current_target: BattleCombatant
	if selected_targets.size() > 0:
			current_target = selected_targets[0]

	match skill.applicable_target:
		BattleEnums.ApplicableTarget.AllEnemy: 
			return _possible_enemy_targets.filter(func(t): return t.is_alive)
		BattleEnums.ApplicableTarget.AllAlly:
			return _possible_ally_targets.filter(func(t): return t.is_alive)
		BattleEnums.ApplicableTarget.All:
			var all_targets: Array[BattleCombatant] = []
			all_targets.append_array(_possible_enemy_targets)
			all_targets.append_array(_possible_ally_targets)
			return all_targets.filter(func(t): return t.is_alive)
		BattleEnums.ApplicableTarget.Self:
			return selected_targets
		BattleEnums.ApplicableTarget.Enemy:
			var to_target: BattleCombatant = find_attack_target(_possible_enemy_targets, current_target)
			if to_target:
				return [to_target]
			return []
		BattleEnums.ApplicableTarget.Ally:
			var to_target: BattleCombatant = find_attack_target(_possible_ally_targets, current_target)
			if to_target:
				return [to_target]
			return []
		_: 
			push_error("unknown applicable target")
			return []


func play_skill_animation(targets: Array[BattleCombatant]) -> void:
	match skill.animation_kind.animation_target:
		AnimationKind.SkillAnimationTargets.Screen:
			var skill_control: SkillEffectControl = SkillEffectControl.build(skill.animation_kind)
			#This allows a handler to push the animation to center screen in battle manager
			BattleEventBus.queued_battle_animation.emit(skill_control)
			await skill_control.play_skill_animation()

		AnimationKind.SkillAnimationTargets.Enemy:
			var target_index: int = 0
			for _target: BattleCombatant in targets:
				var skill_control: SkillEffectControl = SkillEffectControl.build(skill.animation_kind)
				_target.add_skill_animation(skill_control)

				if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
					await skill_control.play_skill_animation()
				else:
					skill_control.play_skill_animation()
					target_index += 1
