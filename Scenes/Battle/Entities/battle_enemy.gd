class_name BattleEnemy
extends Control

@export var stats: Stats

signal acted
signal took_damage

# func _init(_stats: Stats) -> void:
# 	stats = _stats

# func _ready() -> void:
# 	%EnemyInfoPanel.load_enemy(self)


static func build(_stats: Stats) -> BattleEnemy:
	var enemy = BattleEnemy.new()
	enemy.stats = _stats
	return enemy

func act(targets: Array):
	print('enemy turn')
	var target: BattlePlayer = targets.pick_random()
	print('attacking ', target.player_data.player_name)
	target.player_data.player_stats.take_damage(stats.attack)
	get_tree().create_timer(1).timeout.connect(func(): acted.emit())
	acted.emit()

func is_alive() -> bool: return stats.current_hp > 0
