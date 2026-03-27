class_name MultiplierDamageKind
extends DamageKind

@export var damage_multiplyer: float = 1
@export var damage_flux_range: Vector2 = Vector2(.8, 1.2)

func get_damage(stats: Stats) -> float:
	return damage_multiplyer * stats.attack *  randf_range(damage_flux_range.x, damage_flux_range.y)
