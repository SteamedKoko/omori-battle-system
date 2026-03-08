class_name Submenu
extends VBoxContainer

@onready var header_left: RichTextLabel = %HeaderLeft
@onready var header_right: RichTextLabel = %HeaderRight

var submenu_items: Array[Control] = []
var focus_index: int = 0
var is_active: bool = false

signal closed_menu

func _ready() -> void:
	for child in %ItemContainer.get_children():
		child.queue_free()

	submenu_items = []
	BattleEventBus.updated_submenu_title.connect(_update_header)


func load_items(items: Array[Control]) -> void:
	for child in %ItemContainer.get_children():
		%ItemContainer.remove_child(child)
		
	submenu_items = items

	for item in submenu_items:
		%ItemContainer.add_child(item)
	
	focus_index = 0


func open_menu() -> void:
	show()
	submenu_items[0].grab_focus()
	is_active = true


func close_menu() -> void:
	hide()
	closed_menu.emit()
	is_active = false


func _update_header(left: String, right: String) -> void:
	header_left.text = left
	header_right.text = right


func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return

	if event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()
