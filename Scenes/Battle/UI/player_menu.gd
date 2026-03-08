class_name PlayerMenu
extends MarginContainer

signal closed_menu

var is_active: bool = false
var menu_stack: Array[Control] = []
var skills: Array[SkillLabel] = []
# var items: Array[Item] = []
# var toys: Array[Toy] = []

@onready var action_menu: Control = %ActionMenu
@onready var skill_submenu: Submenu = %SkillMenu

signal cleared_skills

func _ready() -> void:
	skill_submenu.hide()
	skill_submenu.closed_menu.connect(func(): 
		action_menu.show()
		%SkillButton.grab_focus()
	)
	%SkillButton.pressed.connect(func():
		action_menu.hide()
		skill_submenu.open_menu()
	)
	%AttackButton.pressed.connect(func(): print('attacked'))
	%AttackButton.grab_focus()

func load_player(data: PlayerData) -> void:
	_clear_skills()
	_load_skills(data)


func open_menu() -> void:
	show()
	%AttackButton.grab_focus()
	is_active = true

func close_menu() -> void:
	hide()
	is_active = false
	closed_menu.emit()


func _clear_skills() -> void:
	for skill in skills:
		skill.queue_free()
	skills = []

func _load_skills(data: PlayerData) -> void:
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		skill_submenu.add_item(instance)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()
