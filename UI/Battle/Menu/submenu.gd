class_name Submenu
extends VBoxContainer

@onready var header_left: RichTextLabel = %HeaderLeft
@onready var header_right: RichTextLabel = %HeaderRight
@onready var target_select: TargetSelect = %TargetSelect

var battle_manager: BattleManager
var submenu_items: Array[Control] = []
var focus_owner: Control
var current_player: BattlePlayer

signal closed_menu
signal chose_command(command: Command)

func _ready() -> void:
	for child in %ItemContainer.get_children():
		child.queue_free()

	submenu_items = []
	BattleEventBus.updated_submenu_title.connect(_update_header)
	target_select.target_selected.connect(_on_target_selected)
	target_select.target_cancelled.connect(_on_target_cancelled)
	battle_manager = get_tree().get_first_node_in_group("BattleManager")

	set_process_unhandled_input(false)
	set_process(false)


func _on_target_selected(target: BattleCombatant) -> void:
	close_menu()
	prepped_command.selected_targets = [target]
	BattleEventBus.player_action_queued.emit(prepped_command)

func _on_target_cancelled() -> void:
	open_menu(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("joy_button_x"):
		_handle_option_pressed(focus_owner)
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("joy_button_o"):
		close_menu()
		closed_menu.emit()
		BattleEventBus.menu_cancelled.emit()
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	_play_sound_if_moved()
	

func _handle_option_pressed(item: Control):
	if item is SkillLabel:
		_on_choose_skill(item.skill)


func load_items(items: Array[Control], _current_player: BattlePlayer) -> void:
	for child in %ItemContainer.get_children():
		%ItemContainer.remove_child(child)
		
	focus_owner = null
	submenu_items = items
	current_player = _current_player

	for item in submenu_items:
		%ItemContainer.add_child(item)
	
var prepped_command: Command

func _on_choose_skill(skill: Skill) -> void:
	if current_player.stats.current_juice < skill.cost:
		BattleEventBus.menu_not_allowed.emit()
		return

	prepped_command = SkillCommand.new(skill, current_player)
	BattleEventBus.menu_confirmed.emit()

	if !skill.can_select_target:
		chose_command.emit(prepped_command)
		return

	close_menu()

	# This can be fixed with a cleaner implementation for target selection
	var select_type: TargetSelect.TargetSelectTypes
	match skill.applicable_target:
		BattleEnums.ApplicableTarget.All:
			select_type = TargetSelect.TargetSelectTypes.ALL
		BattleEnums.ApplicableTarget.Ally:
			select_type = TargetSelect.TargetSelectTypes.ALLY
		BattleEnums.ApplicableTarget.Enemy:
			select_type = TargetSelect.TargetSelectTypes.ENEMY
		_:
			push_error("Unable to target enemies with type: ", skill.applicable_target)

	target_select.start_selection(current_player, select_type, battle_manager)



func open_menu(reset_focus: bool = true) -> void:
	show()
	if submenu_items.size() > 0 and reset_focus:
		focus_owner = submenu_items[0]

	if focus_owner:
		focus_owner.grab_focus()

	set_process_unhandled_input.call_deferred(true)
	set_process.call_deferred(true)


func close_menu() -> void:
	hide()
	set_process_unhandled_input(false)
	set_process(false)


func _play_sound_if_moved() -> void:
	var new_focus = get_viewport().gui_get_focus_owner()
	if focus_owner != new_focus:
		BattleEventBus.menu_moved.emit()
		focus_owner = new_focus


func _update_header(left: String, right: String) -> void:
	header_left.text = left
	header_right.text = right
