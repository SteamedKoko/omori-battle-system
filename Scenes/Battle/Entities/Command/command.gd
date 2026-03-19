class_name Command
extends RefCounted

@warning_ignore('UNUSED_SIGNAL')
signal command_finished

var targets: Array[BattleEnemy] = []

func execute(_battle_manager: BattleManager) -> void:
	pass
