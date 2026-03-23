class_name DamageContainer
extends PanelContainer

@onready var damage_text: Label = %DamageNumber
@onready var damage_container: PanelContainer = %DamageContainer

@export var damage_fade_time: float = .2
@export var length_to_show_damage: float = 1

func show_damage(amount: int) -> void:
	var tween: Tween = get_tree().create_tween()
	damage_text.text = str(amount)
	damage_text.self_modulate = Color.WHITE
	tween.tween_property(damage_container, "modulate:a", 1, damage_fade_time)
	tween.tween_interval(length_to_show_damage)
	tween.tween_property(damage_container, "modulate:a", 0, damage_fade_time)
	await tween.finished
