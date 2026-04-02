class_name DamageContainer
extends PanelContainer

const DAMAGE_NUMBER = preload("uid://bhuhrn5s4d7b1")

@onready var damage_container: PanelContainer = %DamageContainer
@onready var damage_vbox: VBoxContainer = %DamageVBox

@export var damage_fade_time: float = .2
@export var length_to_show_damage: float = 1

@export var damage_color: Color = Color.WHITE
@export var heal_color: Color = Color(0.0, 1.0, 0.49, 1.0)
@export var juice_damage_color: Color = Color.PURPLE
@export var juice_heal_color: Color = Color.YELLOW

func show_damage(amount: int) -> void:
	await _show_number(amount, damage_color)

func show_heal(amount: int) -> void:
	await _show_number(amount, heal_color)

func show_juice_damage(amount: int) -> void:
	await _show_number(amount, juice_damage_color)

func show_juice_heal(amount: int) -> void:
	await _show_number(amount, juice_heal_color)


func _show_number(amount: int, color: Color) -> void:
	var tween: Tween = get_tree().create_tween()
	var damage_label: Label = DAMAGE_NUMBER.instantiate()
	damage_label.text = str(amount)
	damage_label.self_modulate = color

	damage_vbox.add_child(damage_label)

	tween.tween_property(damage_container, "modulate:a", 1, damage_fade_time)
	tween.tween_interval(length_to_show_damage)
	tween.tween_property(damage_container, "modulate:a", 0, damage_fade_time)

	await tween.finished

	damage_label.queue_free()
