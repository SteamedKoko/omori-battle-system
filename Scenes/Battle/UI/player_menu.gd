class_name PlayerMenu
extends MarginContainer

signal cancelled

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


# func open_skill_menu() -> void:
# 	# if skills.size() == 0:
# 	# 	print('no skills womp womp')
#
# 	skill_submenu.open_menu()
# 	# menu_stack.push_back(%SkillMenu)
# 	# skills[0].grab_focus()

# func close_skill_menu() -> void:
# 	%SkillMenu.hide()
# 	%SkillButton.grab_focus()

func _clear_skills() -> void:
	for skill in skills:
		skill.queue_free()
	skills = []

func _load_skills(data: PlayerData) -> void:
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		skill_submenu.add_item(instance)
		# skills.push_back(instance)
		# %SkillContainer.add_child(instance)
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# var current_menu = menu_stack.pop_back()
		# if current_menu:
		# 	current_menu.hide()
		# 	%AttackButton.grab_focus()
		# 	# if menu_stack.size() > 0:
		# 	# 	menu_stack[menu_stack.size()-1].grab_focus()
		#
		# 	get_viewport().set_input_as_handled()
		# 	return

		cancelled.emit()
		get_viewport().set_input_as_handled()
