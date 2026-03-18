class_name PlayerMenu
extends MarginContainer

signal cancel_pressed

var menu_stack: Array[Control] = []
var skills: Array[SkillLabel] = []
# var items: Array[Item] = []
# var toys: Array[Toy] = []

var _player_text: String
var _battle_player: BattlePlayer

var _battle_manager: BattleManager

@onready var action_menu: Control = %ActionMenu
@onready var skill_submenu: Submenu = %SkillMenu
@onready var target_select: TargetSelect = %TargetSelect

var cancel_timer: Timer
var can_press_cancel: bool = true


func _ready() -> void:
	skill_submenu.hide()
	skill_submenu.closed_menu.connect(func(): 
		action_menu.show()
		BattleEventBus.sent_battle_text.emit(_player_text)
		%SkillButton.grab_focus()
	)
	%SkillButton.pressed.connect(func():
		action_menu.hide()
		skill_submenu.open_menu()
	)
	%AttackButton.pressed.connect(func(): 
		print('start selection')
		hide()
		target_select.start_selection(_battle_manager.enemies)
	)
	%AttackButton.grab_focus()
	cancel_timer = Timer.new()
	add_child(cancel_timer)
	cancel_timer.timeout.connect(func(): 
		cancel_timer.stop()
		can_press_cancel = true
	)

	target_select.target_cancelled.connect(func():
		open_menu()
	)

	target_select.target_selected.connect(func(enemy: BattleEnemy):
		# we can have dif kinds of commands like attackcommand, skillcommand etc
		_battle_player.execute_command([enemy])
	)

func load_player(player: BattlePlayer, manager: BattleManager) -> void:
	_clear_skills()
	_load_skills(player.player_data)
	_battle_player = player
	_player_text = "What should %s do?" % player.player_data.player_name
	_battle_manager = manager

func target_enemies() -> void:
	var to_target:Array[BattleEnemy] = _battle_manager.enemies
	to_target[0].target_select()


func open_menu() -> void:
	BattleEventBus.sent_battle_text.emit(_player_text)
	show()
	%AttackButton.grab_focus()

func close_menu() -> void:
	hide()


func _clear_skills() -> void:
	for skill in skills:
		skill.queue_free()
	skills = []

func _load_skills(data: PlayerData) -> void:
	var to_load: Array[Control] = []
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		to_load.push_back(instance)

	skill_submenu.load_items(to_load)


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if cancel_timer.is_stopped():
			can_press_cancel = false
			cancel_timer.start(.2)
		get_viewport().set_input_as_handled()

	if Input.is_action_just_pressed("ui_cancel") and can_press_cancel:
		cancel_pressed.emit()
		get_viewport().set_input_as_handled()
