class_name BattleButton
extends TextureButton

@export var battle_text: String

func _ready() -> void:
	focus_entered.connect(handy_boi_on)
	focus_exited.connect(handy_boi_off)

func handy_boi_on() -> void:
	if battle_text:
		BattleEventBus.sent_battle_text.emit(battle_text)

	%FingerContainer.show()

func handy_boi_off() -> void:
	%FingerContainer.hide()
