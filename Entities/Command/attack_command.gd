class_name AttackCommand
extends Command

var attack_animation: AnimationKind

func _init(_attack_animation: AnimationKind) -> void:
	attack_animation = _attack_animation

func execute(_possible_enemy_targets: Array[BattleCombatant], _possible_ally_targets: Array[BattleCombatant]) -> void:
	BattleEventBus.sent_battle_text.emit('')

	await Engine.get_main_loop().create_timer(1).timeout

	var current_target: BattleCombatant
	if selected_targets.size() > 0:
			current_target = selected_targets[0]

	var is_crit: bool = false
	if randf_range(0, 100) < caster.battle_luck:
		is_crit = true

	var to_attack: BattleCombatant = find_attack_target(_possible_enemy_targets, current_target)
	if !to_attack:
		command_executed.emit()
		return

	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [ caster.get_combatant_name(), to_attack.get_combatant_name() ])

	var effect_control: SkillEffectControl = SkillEffectControl.build(attack_animation)
	if is_crit:
		effect_control.audio_to_play = caster.crit_sound

	to_attack.add_skill_animation(effect_control)
	await effect_control.play_skill_animation()

	attack_target(to_attack, is_crit)

	await Engine.get_main_loop().create_timer(1).timeout

	command_executed.emit()


func attack_target(to_attack: BattleCombatant, is_crit: bool) -> void:
	var damage_calculation: DamageCalculation = DamageCalculation.new()
	if is_crit:
		damage_calculation.is_crit = is_crit

	damage_calculation.base_damage = caster.battle_attack
	damage_calculation.damage_multiplier = 2
	damage_calculation.target_defense = to_attack.battle_defense
	damage_calculation.emotion_multiplier = EmotionHelper.get_emotion_multiplier(caster.current_emotion, to_attack.current_emotion)


	to_attack.take_damage(damage_calculation.crunch_numbers())
