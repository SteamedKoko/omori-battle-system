class_name EnemyInfoPanel
extends PanelContainer

@export var battle_enemy: BattleEnemy

@onready var health_bar: TextureProgressBar = %HealthProgressBar

func _ready() -> void:
	health_bar.max_value = battle_enemy.stats.max_hp
	health_bar.value = battle_enemy.stats.current_hp
	battle_enemy.stats.took_damage.connect(_took_damage)

func toggle_pointer(should_show: bool) -> void:
	if should_show:
		%PointerContainer.show()
		return

	%PointerContainer.hide()

func _took_damage(_amount: int) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(health_bar, 'value', battle_enemy.stats.current_hp, .3)
