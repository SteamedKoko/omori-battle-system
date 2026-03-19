class_name PlayerMenu
extends MarginContainer

signal cancel_pressed

var menu_stack: Array[Control] = []
var skills: Array[SkillLabel] = []
# var items: Array[Item] = []
# var toys: Array[Toy] = []

var can_press_cancel: bool = true
var prepped_command: Command
var is_active: bool
var _player_text: String
var _battle_player: BattlePlayer
var _battle_manager: BattleManager #maybe tmp measure

@onready var action_menu: Control = %ActionMenu
@onready var attack_button: BattleButton = %AttackButton
@onready var cancel_timer: Timer = %CancelTimer
@onready var skill_submenu: Submenu = %SkillMenu
@onready var skill_button: BattleButton = %SkillButton
@onready var target_select: TargetSelect = %TargetSelect

func _ready() -> void:
	skill_submenu.hide()
	attack_button.grab_focus()
	skill_submenu.closed_menu.connect(_on_close_submenu)
	skill_button.pressed.connect(_on_skill_button_pressed)
	attack_button.pressed.connect(_on_attack_button_pressed)
	cancel_timer.timeout.connect(_on_cancel_timer_timeout)
	target_select.target_cancelled.connect(_on_target_cancelled)
	target_select.target_selected.connect(_on_target_selected)

func _unhandled_input(_event: InputEvent) -> void:
	if !is_active:
		return

	if Input.is_action_just_pressed("ui_accept"):
		if cancel_timer.is_stopped():
			can_press_cancel = false
			cancel_timer.start(.2)
			get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_cancel") and can_press_cancel:
		cancel_pressed.emit()
		get_viewport().set_input_as_handled()


func load_player(player: BattlePlayer, manager: BattleManager) -> void:
	prepped_command = null
	_load_skills(player.player_data)
	_battle_player = player
	_player_text = "What should %s do?" % player.player_data.player_name
	_battle_manager = manager


func target_enemies() -> void:
	var to_target:Array[BattleEnemy] = _battle_manager.enemies
	to_target[0].target_select()


func open_menu() -> void:
	is_active = true
	BattleEventBus.sent_battle_text.emit(_player_text)
	show()
	attack_button.grab_focus()


func _load_skills(data: PlayerData) -> void:
	# clear out the current skills
	for skill in skills:
		skill.queue_free()

	skills = []
	var to_load: Array[Control] = []
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		to_load.push_back(instance)

	skill_submenu.load_items(to_load)


func _on_target_selected(enemy: BattleEnemy) -> void:
	is_active = false
	prepped_command.targets = [enemy]
	BattleEventBus.player_action_queued.emit(prepped_command)


func _on_target_cancelled() -> void:
	prepped_command = null
	open_menu()


func _on_cancel_timer_timeout() -> void:
	cancel_timer.stop()
	can_press_cancel = true


func _on_attack_button_pressed() -> void:
	prepped_command = AttackCommand.new()
	prepped_command.battle_player = _battle_player
	hide()
	target_select.start_selection(_battle_manager.enemies)


func _on_skill_button_pressed() -> void:
	action_menu.hide()
	skill_submenu.open_menu()


func _on_close_submenu() -> void:
	action_menu.show()
	BattleEventBus.sent_battle_text.emit(_player_text)
	skill_button.grab_focus()
