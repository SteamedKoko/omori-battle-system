class_name AttackCommand
extends Command

var battle_player: BattlePlayer

func execute() -> void:
	#do some calculation for how HEAVY the attack is
	#dif emotions change how strong an attack is or up the crit rate to deal additional dmg
	for target in targets:
		target.stats.take_damage(battle_player.player_data.player_stats.attack)

	await Engine.get_main_loop().create_timer(1).timeout
