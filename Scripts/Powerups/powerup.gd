extends Area2D
@export var speed = 150

func _process(delta: float) -> void:
	translate(Vector2.LEFT * speed * delta)
