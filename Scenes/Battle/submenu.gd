class_name Submenu
extends VBoxContainer

var submenu_items: Array[Control] = []
var focus_index: int = 0

signal closed_menu

func _ready() -> void:
	for child in %ItemContainer.get_children():
		child.queue_free()

	submenu_items = []

func load_items(items: Array[Control]) -> void:
	submenu_items = items
	focus_index = 0

func add_item(item: Control) -> void:
	submenu_items.push_back(item)
	%ItemContainer.add_child(item)

func open_menu() -> void:
	show()
	submenu_items[0].grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()
		closed_menu.emit()
		get_viewport().set_input_as_handled()
