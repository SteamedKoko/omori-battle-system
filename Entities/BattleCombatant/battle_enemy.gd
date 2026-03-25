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
	var to_attack: Array[BattlePlayer] = _determine_targets(skill.applicable_target, targets)

	BattleEventBus.sent_battle_text.emit("%s performs %s\n" % [enemy_data.enemy_name, skill.name])
	BattleEventBus.queued_sound_effect.emit(skill.sound)

	await _play_skill_animation_on_targets(skill, to_attack)

	_set_target_mood(skill.target_effect_status, to_attack)
	_damage_targets(skill.damage, to_attack)

	await Engine.get_main_loop().create_timer(2).timeout

	acted.emit()

func _determine_targets(applicable_target: Skill.ApplicableTarget ,targets: Array[BattlePlayer]) -> Array[BattlePlayer]:
	var to_attack: Array[BattlePlayer]
	match applicable_target:
		Skill.ApplicableTarget.AllEnemy: return targets
		Skill.ApplicableTarget.Enemy: return [targets.pick_random()]

	return to_attack
			

func _set_target_mood(new_mood: Skill.MoodType, targets: Array[BattlePlayer]) -> void:
	if new_mood == Skill.MoodType.None:
		return

	for target: BattlePlayer in targets:
		if new_mood == Skill.MoodType.Random:
			target.set_random_mood()
		else:
			var new_emotion: PlayerData.Emotions = _get_emotion_from_mood(new_mood)
			target.set_emotion(new_emotion)


func _get_emotion_from_mood(from_mood: Skill.MoodType) -> PlayerData.Emotions:
	match from_mood:
		Skill.MoodType.Happy: return PlayerData.Emotions.HAPPY
		Skill.MoodType.MoreHappy: return PlayerData.Emotions.ECSTATIC
		Skill.MoodType.VeryHappy: return PlayerData.Emotions.MANIC
		Skill.MoodType.Sad: return PlayerData.Emotions.SAD
		Skill.MoodType.MoreSad: return PlayerData.Emotions.DEPRESSED
		Skill.MoodType.VerySad: return PlayerData.Emotions.MISERABLE
		Skill.MoodType.Angry: return PlayerData.Emotions.ANGRY
		Skill.MoodType.MoreAngry: return PlayerData.Emotions.ENRAGED
		Skill.MoodType.VeryAngry: return PlayerData.Emotions.FURIOUS
		_: return PlayerData.Emotions.NEUTRAL


func _damage_targets(damage_to_deal: float, targets: Array[BattlePlayer]) -> void:
	for target: BattlePlayer in targets:
		target.take_damage(floor(damage_to_deal))


func _play_skill_animation_on_targets(skill: Skill, targets: Array[BattlePlayer]) -> void:
	var target_index: int = 0
	for target: BattlePlayer in targets:
		var skill_control: SkillEffectControl = SkillEffectControl.build(skill)
		target.player_panel.effect_container.add_child(skill_control)

		if target_index == targets.size() - 1: # Only wait for the last one, hacky I know
			await skill_control.play_skill_animation()
		else:
			skill_control.play_skill_animation()
			target_index += 1
	

func attack(targets: Array[BattlePlayer]) -> void:
	var target: BattlePlayer = targets.pick_random()
	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [enemy_data.enemy_name, target.player_data.player_name])
	target.player_data.player_stats.take_damage(stats.attack)
	await Engine.get_main_loop().create_timer(1).timeout
	BattleEventBus.sent_battle_text_append.emit('%s takes %s damage' % [target.player_data.player_name, stats.attack])
	await Engine.get_main_loop().create_timer(1).timeout
	acted.emit()


func act(targets: Array):
	BattleEventBus.sent_battle_text.emit("")
	if enemy_data.skills.size() > 0:
		use_skill(enemy_data.skills[0], targets)
		return

	attack(targets)
