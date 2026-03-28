class_name TargetSelect
extends Control

signal target_cancelled()
signal target_selected(enemy: BattleEnemy)

const TARGET_SELECT = preload("uid://dv2gygkgghfb6")

var enemies: Array[BattleCombatant]
var enemy_index: int = 0

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		try_move(-1)
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_right"):
		try_move(1)
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_accept"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_confirmed.emit()
		enemies[enemy_index].target_deselect()
		target_selected.emit(enemies[enemy_index])
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_cancel"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_cancelled.emit()
		enemies[enemy_index].target_deselect()
		target_cancelled.emit()
		get_viewport().set_input_as_handled()
		
func try_move(index_increment: int) -> void:
	var index_before = enemy_index
	change_target(index_increment)
	if index_before != enemy_index:
		BattleEventBus.menu_moved.emit()


	
func start_selection(enemy_array: Array[BattleCombatant]) -> void:
	enemies = enemy_array
	enemy_index = 0
	change_target(0)
	# Mind BLOWN, I need to call deferred here, otherwise the target will immediately be selected as soon as the menu opens
	# even though is_action_just_pressed is being used
	set_process_unhandled_input.call_deferred(true)

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
	
