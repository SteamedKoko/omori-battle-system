class_name BattleEnemy
extends Node

var stats: Stats

signal acted
signal took_damage

func _init(_stats: Stats) -> void:
	stats = _stats

func act():
	print('enemy turn')
	get_tree().create_timer(1).timeout.connect(func(): acted.emit())

func is_alive() -> bool: return stats.current_hp > 0
