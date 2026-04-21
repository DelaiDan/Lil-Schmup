extends Area2D
class_name BasePlayerProjectile

var speed_base: int = 500;
var damage_base: int = 1;
var fire_delay_base: float = 0.1;
var pickup_score_base: int = 50;

func _process(delta: float) -> void:
	translate(Vector2.RIGHT * speed_base * delta);
	
func get_fire_delay() -> float:
	return fire_delay_base;

func get_damage() -> int:
	return damage_base;

func get_pickup_score() -> int:
	return pickup_score_base;
