class_name AttackCommand
extends Command

var battle_player: BattlePlayer

func execute(battle_manager: BattleManager) -> void:
	#do some calculation for how HEAVY the attack is
	#dif emotions change how strong an attack is or up the crit rate to deal additional dmg
	BattleEventBus.sent_battle_text.emit('')
	var player_name: String = battle_player.player_data.player_name
	var initial_damage: int = battle_player.player_data.player_stats.attack
	#do the attack animation from the player onto the enemy and wait for it to finish

	await Engine.get_main_loop().create_timer(1).timeout
	#now actually do the damage to the enemies and queue up all the ui indicators of it happening
	#calculations all happen here
	for target in targets:
		var to_attack: BattleEnemy = target
		if !target.is_alive():
			var alive_enemies = battle_manager.alive_enemies()
			if alive_enemies.size() == 0:
				break

			to_attack = alive_enemies.pick_random()

		var enemy_name: String = to_attack.enemy_data.enemy_name
		var damage_to_deal: int = initial_damage * 10
		BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [ player_name, enemy_name ])
		BattleEventBus.sent_battle_text_append.emit('%s takes %s damage!' % [ enemy_name, damage_to_deal ])
		await Engine.get_main_loop().create_timer(1).timeout
		to_attack.stats.take_damage(damage_to_deal)


	command_finished.emit()
