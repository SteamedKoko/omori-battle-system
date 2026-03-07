extends TextureButton

func _ready() -> void:
	focus_entered.connect(handy_boi_on)
	focus_exited.connect(handy_boi_off)

func handy_boi_on() -> void:
	%FingerContainer.show()

func handy_boi_off() -> void:
	%FingerContainer.hide()
