class_name BattleAction
extends RefCounted

var caster: BattlePlayer
var targets: Array[BattleEnemy]
var action_type: ActionTypes

enum ActionTypes {
	Attack,
	Skill,
	Item,
	Toy
}

func execute() -> void:
	for target in targets:
		target.stats.take_damage(caster.player_data.player_stats.attack)
	
	await Engine.get_main_loop().create_timer(1).timeout
