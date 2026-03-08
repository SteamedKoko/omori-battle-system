class_name PlayerMenu
extends MarginContainer

signal closed_menu

var is_active: bool = false
var menu_stack: Array[Control] = []
var skills: Array[SkillLabel] = []
# var items: Array[Item] = []
# var toys: Array[Toy] = []

var _player_text: String
var _battle_player: BattlePlayer

@onready var action_menu: Control = %ActionMenu
@onready var skill_submenu: Submenu = %SkillMenu

signal cleared_skills

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
	%AttackButton.pressed.connect(func(): _battle_player.execute_command())
	%AttackButton.grab_focus()

func load_player(player: BattlePlayer) -> void:
	_clear_skills()
	_load_skills(player.player_data)
	_battle_player = player
	_player_text = "What should %s do?" % player.player_data.player_name


func open_menu() -> void:
	BattleEventBus.sent_battle_text.emit(_player_text)
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
	var to_load: Array[Control] = []
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		to_load.push_back(instance)

	skill_submenu.load_items(to_load)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()
