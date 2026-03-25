class_name Submenu
extends VBoxContainer

@onready var header_left: RichTextLabel = %HeaderLeft
@onready var header_right: RichTextLabel = %HeaderRight

var submenu_items: Array[Control] = []
var focus_owner: Control

signal closed_menu

func _ready() -> void:
	for child in %ItemContainer.get_children():
		child.queue_free()

	submenu_items = []
	BattleEventBus.updated_submenu_title.connect(_update_header)
	set_process_unhandled_input(false)
	set_process(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_menu()
		BattleEventBus.menu_cancelled.emit()
		get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	_play_sound_if_moved()
	

func load_items(items: Array[Control]) -> void:
	for child in %ItemContainer.get_children():
		%ItemContainer.remove_child(child)
		
	submenu_items = items

	for item in submenu_items:
		%ItemContainer.add_child(item)
	

func open_menu() -> void:
	show()
	if submenu_items.size() > 0:
		focus_owner = submenu_items[0]
		submenu_items[0].grab_focus()

	set_process_unhandled_input.call_deferred(true)
	set_process.call_deferred(true)


func close_menu() -> void:
	hide()
	closed_menu.emit()
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
