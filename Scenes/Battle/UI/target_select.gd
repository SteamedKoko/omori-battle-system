class_name TargetSelect
extends Control

const TARGET_SELECT = preload("uid://dv2gygkgghfb6")

signal target_cancelled()
signal target_selected(enemy: BattleEnemy)

var enemies: Array[BattleEnemy]
var enemy_index: int = 0
var is_active = false

# static func build(enemiesArray: Array[BattleEnemy]) -> TargetSelect:
# 	var instance: TargetSelect = TARGET_SELECT.instantiate()
# 	instance.enemies = enemiesArray
#
# 	return instance

# func _ready() -> void:
# 	change_target(0)

func start_selection(enemiesArray: Array[BattleEnemy]) -> void:
	enemies = enemiesArray
	is_active = true
	enemy_index = 0
	change_target(0)

func change_target(amount_to_increase: int) -> void:
	var amount: int = enemy_index + amount_to_increase
	var new_index: int = clampi(amount, 0, enemies.size() -1)

	enemies[enemy_index].target_deselect()
	enemy_index = new_index
	enemies[enemy_index].target_select()

func target_toggle(enemy: BattleEnemy, target_on: bool) -> void:
	if target_on:
		enemy.target_select()
		return

	enemy.target_deselect()
	
func toggle_target_all(target_on: bool) -> void:
	for enemy in enemies:
		target_toggle(enemy, target_on)
	

func _unhandled_input(_event: InputEvent) -> void:
	if !is_active:
		return

	if Input.is_action_just_pressed("ui_left"):
		change_target(-1)
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_right"):
		change_target(1)
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_accept"):
		print('turn it off obi')
		is_active = false
		enemies[enemy_index].target_deselect()
		target_selected.emit(enemies[enemy_index])
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_cancel"):
		is_active = false
		enemies[enemy_index].target_deselect()
		target_cancelled.emit()
		get_viewport().set_input_as_handled()
		
