extends BasePlayerProjectile

var speed: int = 800
var fire_delay: float = 0.1
var damage: int = 1
var pickup_score: int = 0

func _init() -> void:
	speed_base = speed
	fire_delay_base = fire_delay
	damage_base = damage
	pickup_score_base = pickup_score
