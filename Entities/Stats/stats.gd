class_name Stats
extends Resource

signal took_damage(amount: int)
signal used_juice(amount: int)
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
@export var luck: int

var is_alive: bool:
	get: return current_hp > 0

func take_damage(amount: int) -> void:
	var damage_to_take = maxi(amount, 0)
	current_hp = maxi(current_hp - damage_to_take, 0)
	took_damage.emit(damage_to_take)
	if current_hp == 0:
		toasted.emit()

func lose_juice(amount: int) -> void:
	var juice_to_use = maxi(amount, 0)
	current_juice = maxi(current_juice - juice_to_use, 0)
	used_juice.emit(juice_to_use)
