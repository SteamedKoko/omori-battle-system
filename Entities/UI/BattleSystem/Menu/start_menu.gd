class_name StartMenu
extends VBoxContainer

signal attempted_fight
signal attempted_run

var focus_owner: Control

@onready var fight_button: BattleButton = %FightButton
@onready var run_button: BattleButton = %RunButton

func _ready() -> void:
	focus_owner = fight_button
	fight_button.pressed.connect(func(): attempted_fight.emit())
	run_button.pressed.connect(func(): attempted_run.emit())
	

func _process(_delta: float) -> void:
	_play_sound_if_moved()

func open_menu() -> void:
	focus_owner = fight_button
	fight_button.grab_focus()
	set_process(true)
	show()

func close_menu() -> void:
	set_process(false)
	hide()


func _play_sound_if_moved() -> void:
	var new_focus = get_viewport().gui_get_focus_owner()
	if focus_owner != new_focus:
		BattleEventBus.menu_moved.emit()
		focus_owner = new_focus
