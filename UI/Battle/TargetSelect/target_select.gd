class_name TargetSelect
extends Control

signal target_cancelled()
signal target_selected(enemy: BattleEnemy)

const TARGET_SELECT = preload("uid://dv2gygkgghfb6")

var enemies: Array[BattleEnemy]
var enemy_index: int = 0

var allies: Array[BattlePlayer]
var ally_index: int = 0

var acting_player: BattlePlayer

# This is so shit I love it, using this to determine the index that can move based on which party member is currently active, 0% scalable
# If we wanted to scale this, the portraits would need to have directions assigned to them so that we could pull the information from there and load this dynamically
var ally_target_matrix: Array = [
	{Directions.Down: 0, Directions.Left: 0, Directions.Up: 1, Directions.Right: 2},
	{Directions.Down: -1, Directions.Left: 0, Directions.Up: 0, Directions.Right: 2},
	{Directions.Down: 0, Directions.Left: -2, Directions.Up: 1, Directions.Right: 0},
	{Directions.Down: -1, Directions.Left: -2, Directions.Up: 0, Directions.Right: 0},
]

enum Directions {
	Up,
	Down,
	Left,
	Right
}

var current_target_select_type: TargetSelectTypes
var target_select_type: TargetSelectTypes

enum TargetSelectTypes {
	ENEMY,
	ALLY,
	ALL
}

func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(_event: InputEvent) -> void:
	handle_enemy_controls(_event)
	handle_ally_controls(_event)

		

func handle_ally_controls(_event: InputEvent) -> void:
	if current_target_select_type != TargetSelectTypes.ALLY:
		return 

	if Input.is_action_just_pressed("joy_button_square") and target_select_type == TargetSelectTypes.ALL:
		allies[ally_index].unfocus_player()
		acting_player.focus_player()
		enemies[enemy_index].target_select()
		set_deferred("current_target_select_type", TargetSelectTypes.ENEMY)
		BattleEventBus.menu_moved.emit()
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("up"):
		change_ally_target(Directions.Up)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("down"):
		change_ally_target(Directions.Down)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("left"):
		change_ally_target(Directions.Left)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("right"):
		change_ally_target(Directions.Right)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("joy_button_x"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_confirmed.emit()
		allies[ally_index].unfocus_player()
		target_selected.emit(allies[ally_index])
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("joy_button_o"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_cancelled.emit()
		allies[ally_index].unfocus_player()
		acting_player.focus_player()
		target_cancelled.emit()
		get_viewport().set_input_as_handled()



func handle_enemy_controls(_event: InputEvent) -> void:
	if current_target_select_type != TargetSelectTypes.ENEMY:
		return 

	if Input.is_action_just_pressed("joy_button_square") and target_select_type == TargetSelectTypes.ALL:
		enemies[enemy_index].target_deselect()
		acting_player.focus_player()
		ally_index = allies.find(acting_player)
		set_deferred("current_target_select_type", TargetSelectTypes.ALLY)
		get_viewport().set_input_as_handled()
		BattleEventBus.menu_moved.emit()
		return

	if Input.is_action_just_pressed("left"):
		change_enemy_target(-1)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("right"):
		change_enemy_target(1)
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("joy_button_x"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_confirmed.emit()
		enemies[enemy_index].target_deselect()
		target_selected.emit(enemies[enemy_index])
		get_viewport().set_input_as_handled()
		return

	if Input.is_action_just_pressed("joy_button_o"):
		set_process_unhandled_input(false)
		BattleEventBus.menu_cancelled.emit()
		enemies[enemy_index].target_deselect()
		target_cancelled.emit()
		get_viewport().set_input_as_handled()


func start_attack_selection(targets: Array[BattleEnemy]) -> void:
	enemies = targets
	enemy_index = 0
	target_select_type = TargetSelectTypes.ENEMY
	enemies[enemy_index].target_select()
	set_process_unhandled_input.call_deferred(true)


func start_selection(current_player: BattlePlayer, target_type: TargetSelectTypes, manager: BattleManager) -> void:
	enemies = manager.alive_enemies
	enemy_index = 0

	allies = []
	for player: BattlePlayer in manager.players:
		allies.push_back(player)
	
	acting_player = current_player

	target_select_type = target_type
	BattleEventBus.sent_battle_text.emit("Use on whom?")
	match target_type:
		TargetSelectTypes.ALL, TargetSelectTypes.ALLY:
			current_target_select_type = TargetSelectTypes.ALLY
			ally_index = allies.find(acting_player)
			if target_select_type == TargetSelectTypes.ALL:
				BattleEventBus.sent_battle_text_append.emit("\nPress U to toggle")
		_:
			current_target_select_type = TargetSelectTypes.ENEMY
			enemies[enemy_index].target_select()

	# Mind BLOWN, I need to call deferred here, otherwise the target will immediately be selected as soon as the menu opens
	# even though is_action_just_pressed is being used
	set_process_unhandled_input.call_deferred(true)


func change_ally_target(direction: Directions) -> void:
	var amount_to_increase: int = ally_target_matrix[ally_index][direction]
	var amount: int = ally_index + amount_to_increase
	var new_index: int = clampi(amount, 0, allies.size() - 1)

	if new_index == ally_index:
		return

	BattleEventBus.menu_moved.emit()
	allies[ally_index].unfocus_player()
	ally_index = new_index
	allies[ally_index].focus_player()

func change_enemy_target(amount_to_increase: int) -> void:
	var amount: int = enemy_index + amount_to_increase
	var new_index: int = clampi(amount, 0, enemies.size() -1)

	if new_index == enemy_index:
		return 

	BattleEventBus.menu_moved.emit()
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
	
