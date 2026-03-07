class_name Stats
extends Resource

signal took_damage(amount: int)
signal healed_health
signal revived
signal toasted

@export var max_hp: int
@export var max_juice: int

@export var level: int
@export var experience: int

@export var current_hp: int
@export var current_juice: int
@export var attack: int
@export var defense: int
@export var speed: int

func take_damage(amount: int) -> void:
	var damage_to_take = maxi(amount - defense, 0)
	current_hp = maxi(current_hp - damage_to_take, 0)
	if current_hp == 0:
		toasted.emit()
