class_name EnemyInfoPanel
extends PanelContainer


@onready var health_bar: TextureProgressBar = %HealthProgressBar
@onready var enemy_name_label: Label = %EnemyName

var enemy_data: EnemyData:
	set = _set_data

func _set_data(data: EnemyData) -> void:
	assert(data != null, "Enemy data required in EnemyInfoPanel")
	health_bar.max_value = data.stats.max_hp
	health_bar.value = data.stats.current_hp
	enemy_name_label.text = data.enemy_name
	data.stats.took_damage.connect(_took_damage)
	enemy_data = data

func toggle_pointer(should_show: bool) -> void:
	if should_show:
		%PointerContainer.show()
		return

	%PointerContainer.hide()

func _took_damage(_amount: int) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(health_bar, 'value', enemy_data.stats.current_hp, .3)
