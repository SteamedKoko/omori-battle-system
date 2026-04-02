class_name ScreenShake
extends CanvasLayer

@export var amount_to_shake: Vector2 = Vector2(8, 0)
@export var shake_duration: float = .05
@export var shake_loops: int = 3


func shake_screen(is_strong: bool) -> void:
	var tween: Tween = create_tween()

	for i in range(shake_loops):
		tween.tween_property(self, "offset", amount_to_shake, shake_duration).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "offset", -amount_to_shake, shake_duration).set_trans(Tween.TRANS_BOUNCE)

	tween.tween_property(self, "offset", Vector2(0, 0), shake_duration)
