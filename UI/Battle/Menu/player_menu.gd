class_name PlayerMenu
extends MarginContainer

signal cancel_pressed

var menu_stack: Array[Control] = []
var skills: Array[SkillLabel] = []
# var items: Array[Item] = []
# var toys: Array[Toy] = []

var prepped_command: Command
var _player_text: String
var _battle_player: BattlePlayer

var available_enemies: Array[BattleCombatant]

@onready var action_menu: Control = %ActionMenu
@onready var attack_button: BattleButton = %AttackButton
@onready var skill_button: BattleButton = %SkillButton
@onready var toy_button: BattleButton = %ToyButton
@onready var snack_button: BattleButton = %SnackButton

@onready var skill_submenu: Submenu = %SkillMenu
@onready var target_select: TargetSelect = %TargetSelect

@onready var focus_owner: Control = %AttackButton

func _ready() -> void:
	_toggle_process(false)
	skill_submenu.hide()
	attack_button.grab_focus()

	attack_button.pressed.connect(_on_attack_button_pressed)
	skill_button.pressed.connect(_on_skill_button_pressed)
	snack_button.pressed.connect(func(): BattleEventBus.menu_not_allowed.emit())
	toy_button.pressed.connect(func(): BattleEventBus.menu_not_allowed.emit())

	skill_submenu.chose_command.connect(_on_chose_command)
	skill_submenu.closed_menu.connect(_on_close_submenu)

	target_select.target_cancelled.connect(_on_target_cancelled)
	target_select.target_selected.connect(_on_target_selected)


func _process(_delta: float) -> void:
	_play_sound_if_moved()


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		cancel_pressed.emit()
		BattleEventBus.menu_cancelled.emit()
		_toggle_process(false)
		get_viewport().set_input_as_handled()


func load_player(player: BattlePlayer, manager: BattleManager) -> void:
	prepped_command = null
	_battle_player = player
	_load_skills(player.player_data)
	_player_text = "What should %s do?" % player.player_data.player_name
	available_enemies = manager.alive_enemies()


func target_enemies() -> void:
	var to_target: Array[BattleCombatant] = available_enemies
	to_target[0].target_select()


func open_menu() -> void:
	BattleEventBus.sent_battle_text.emit(_player_text)
	show()
	action_menu.show()
	attack_button.grab_focus()
	_toggle_process.call_deferred(true) #need to call deferred here or else navigating backwards breaks


func _play_sound_if_moved() -> void:
	var new_focus = get_viewport().gui_get_focus_owner()
	if focus_owner != new_focus:
		BattleEventBus.menu_moved.emit()
		focus_owner = new_focus


func _load_skills(data: PlayerData) -> void:
	# clear out the current skills
	for skill in skills:
		skill.queue_free()

	skills = []
	var to_load: Array[Control] = []
	for skill in data.skills:
		var instance: SkillLabel = SkillLabel.build(skill)
		to_load.push_back(instance)

	skill_submenu.load_items(to_load, _battle_player)


func _on_target_selected(enemy: BattleCombatant) -> void:
	prepped_command.selected_targets = [enemy]
	BattleEventBus.player_action_queued.emit(prepped_command)


func _on_target_cancelled() -> void:
	_toggle_process(true)
	prepped_command = null
	open_menu()


func _on_attack_button_pressed() -> void:
	_toggle_process(false)
	BattleEventBus.menu_confirmed.emit()
	prepped_command = AttackCommand.new(_battle_player.player_data.attack_animation)
	prepped_command.caster = _battle_player
	hide()
	target_select.start_selection(available_enemies)

func _on_skill_button_pressed() -> void:
	_toggle_process(false)
	BattleEventBus.menu_confirmed.emit()
	action_menu.hide()
	skill_submenu.open_menu()

func _on_chose_command(command: Command) -> void:
	skill_submenu.close_menu()
	hide()
	command.caster = _battle_player
	BattleEventBus.player_action_queued.emit(command)


func _on_close_submenu() -> void:
	action_menu.show()
	_toggle_process(true)
	BattleEventBus.sent_battle_text.emit(_player_text)
	skill_button.grab_focus()


func _toggle_process(enable: bool) -> void:
	set_process(enable)
	set_process_unhandled_input(enable)
	set_process_input(enable)
