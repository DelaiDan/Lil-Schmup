extends Area2D

var speed = 250;

func _process(delta: float) -> void:
	translate(Vector2.LEFT * speed * delta);
