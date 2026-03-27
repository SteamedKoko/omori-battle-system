class_name DamageContainer
extends PanelContainer

const DAMAGE_NUMBER = preload("uid://bhuhrn5s4d7b1")

@onready var damage_container: PanelContainer = %DamageContainer
@onready var damage_vbox: VBoxContainer = %DamageVBox

@export var damage_fade_time: float = .2
@export var length_to_show_damage: float = 1

func show_damage(amount: int) -> void:
	var tween: Tween = get_tree().create_tween()
	var damage_label: Label = DAMAGE_NUMBER.instantiate()
	damage_label.text = str(amount)
	damage_label.self_modulate = Color.WHITE

	damage_vbox.add_child(damage_label)

	tween.tween_property(damage_container, "modulate:a", 1, damage_fade_time)
	tween.tween_interval(length_to_show_damage)
	tween.tween_property(damage_container, "modulate:a", 0, damage_fade_time)

	await tween.finished

	damage_label.queue_free()
