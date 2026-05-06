extends Area2D

var speed = 500;

func _process(delta: float) -> void:
	translate(Vector2.LEFT * speed * delta);
