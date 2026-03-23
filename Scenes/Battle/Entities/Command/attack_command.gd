class_name AttackCommand
extends Command

var battle_player: BattlePlayer

func execute(battle_manager: BattleManager) -> void:
	BattleEventBus.sent_battle_text.emit('')
	var initial_damage: int = battle_player.player_data.player_stats.attack

	await Engine.get_main_loop().create_timer(1).timeout

	#calculations all happen here
	for target in targets:
		var to_attack: BattleEnemy = find_target(battle_manager, target)
		if !to_attack:
			break

		# TODO: Bro maybe we need to do more here based on emotions etc
		var damage_to_deal: int = initial_damage

		BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [ battle_player.player_name, target.enemy_name ])
		await Engine.get_main_loop().create_timer(1).timeout
		to_attack.deal_damage(damage_to_deal)

	await Engine.get_main_loop().create_timer(1).timeout

	command_finished.emit()

func find_target(battle_manager: BattleManager, target: BattleEnemy) -> BattleEnemy:
	var to_attack: BattleEnemy = target
	if !target.is_alive():
		var alive_enemies = battle_manager.alive_enemies()
		if alive_enemies.size() == 0:
			return

		to_attack = alive_enemies.pick_random()

	return to_attack
