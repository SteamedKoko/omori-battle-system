class_name SkillCommand
extends Command

var skill: Skill

func _init(_skill: Skill, _caster: BattleCombatant) -> void:
	skill = _skill
	caster = _caster

func execute(_possible_enemies: Array[BattleCombatant], _possible_allies: Array[BattleCombatant]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	await Engine.get_main_loop().create_timer(1).timeout

	var alive_targets: Array[BattleCombatant] = determine_targets(_possible_enemies, _possible_allies)
	if alive_targets.size() == 0:
		command_executed.emit()
		return

	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [caster.get_combatant_name(), skill.name])

	await play_skill_animation(alive_targets)

	#damage the targets
	for i in range(skill.times_to_hit):
		for current_target: BattleCombatant in alive_targets:
			var to_attack: BattleCombatant = find_attack_target(alive_targets, current_target)
			if !to_attack:
				break
			attack_target(to_attack)

			if skill.can_set_target_emotion:
				if skill.is_emotion_random:
					current_target.set_random_emotion()
				else:
					current_target.set_emotion(skill.set_target_emotion)

		alive_targets = determine_targets(_possible_enemies, _possible_allies)

	if skill.can_set_caster_emotion:
		caster.set_emotion(skill.set_caster_emotion)

	#TODO: Probably apply debuffs here

	await Engine.get_main_loop().create_timer(1).timeout
	command_executed.emit()


func determine_targets(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> Array[BattleCombatant]:
	var current_target: BattleCombatant
	if selected_targets.size() > 0:
			current_target = selected_targets[0]

	match skill.applicable_target:
		Skill.ApplicableTarget.AllEnemy: 
			return _possible_enemy_targets.filter(func(t): return t.is_alive)
		Skill.ApplicableTarget.AllAlly:
			return _possible_ally_targets.filter(func(t): return t.is_alive)
		Skill.ApplicableTarget.All:
			var all_targets: Array[BattleCombatant] = []
			all_targets.append_array(_possible_enemy_targets)
			all_targets.append_array(_possible_ally_targets)
			return all_targets.filter(func(t): return t.is_alive)
		Skill.ApplicableTarget.Self:
			return selected_targets
		Skill.ApplicableTarget.Enemy:
			var to_target: BattleCombatant = find_attack_target(_possible_enemy_targets, current_target)
			if to_target:
				return [to_target]
			return []
		Skill.ApplicableTarget.Ally:
			var to_target: BattleCombatant = find_attack_target(_possible_ally_targets, current_target)
			if to_target:
				return [to_target]
			return []
		_: 
			push_error("unknown applicable target")
			return []

func get_base_stat(base_stat_type: Skill.StatType) -> float:
	match base_stat_type:
		Skill.StatType.Attack: return caster.battle_attack
		Skill.StatType.Luck: return caster.battle_luck
		Skill.StatType.Speed: return caster.battle_speed
		Skill.StatType.Defense: return caster.battle_defense
		_: return 0

func attack_target(target: BattleCombatant) -> void:
	var calculated_damage: float = 0
	for base_stat in skill.base_damage_stat:
		calculated_damage += get_base_stat(base_stat)
		
	var damage_multiplier: float = skill.damage_multiplyer
	if skill.has_damage_override:
		if skill.damage_multiplier_override_emotion == caster.current_emotion:
			damage_multiplier = skill.damage_multiplier_override

	calculated_damage *= damage_multiplier
	calculated_damage -= target.stats.defense
	calculated_damage *= randf_range(skill.damage_variance.x, skill.damage_variance.y)
	target.take_damage(round(calculated_damage))

#This value varies depending only on the defender's emotion tier. So, for example, if the attacker is ecstatic and the defender is angry, the attack will only deal 50% more damage, while if the attacker is angry but the defender is ecstatic, the attack will deal 35% less damage.
# * Emotion Resistance: Takes 20% / 35% / 50% less damage from the weaker emotion.
# * Emotion Weakness: Deals 50% / 100% / 150% more damage to the weaker emotion.
# func get_emotion_multiplier(caster_emotion: PlayerData.Emotions, target_emotion: PlayerData.Emotions) -> float:
# 	pass

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
