class_name AttackCommand
extends Command

func execute(alive_enemies: Array[BattleEnemy]) -> void:
	BattleEventBus.sent_battle_text.emit('')
	var initial_damage: int = battle_player.player_data.player_stats.attack

	await Engine.get_main_loop().create_timer(1).timeout

	#calculations all happen here
	var to_attack: BattleEnemy = find_target(alive_enemies, target)
	if !to_attack:
		return

	# TODO: Bro maybe we need to do more here based on emotions etc
	var damage_to_deal: int = initial_damage

	BattleEventBus.sent_battle_text_append.emit('%s attacks %s\n' % [ battle_player.player_name, target.enemy_name ])
	await Engine.get_main_loop().create_timer(1).timeout
	to_attack.take_damage(damage_to_deal)

	await Engine.get_main_loop().create_timer(1).timeout
