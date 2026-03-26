class_name Command
extends RefCounted

var targets: Array[BattleEnemy] = []
var battle_player: BattlePlayer

func execute(_alive_enemies: Array[BattleEnemy]) -> void:
	pass

func find_target(alive_enemies: Array[BattleEnemy], target: BattleEnemy) -> BattleEnemy:
	var to_attack: BattleEnemy = target
	if !target.is_alive:
		if alive_enemies.size() == 0:
			return

		to_attack = alive_enemies.pick_random()

	return to_attack
