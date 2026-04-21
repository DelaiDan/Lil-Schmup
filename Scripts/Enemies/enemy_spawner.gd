extends Node2D

@export var active: bool = true
@export var enemy_prefab: PackedScene
@export var quantity: int
@export var delay: float

@export var area_size_x: float = 1.0
@export var area_size_y: float = 10.0

@onready var timer: Timer = $Timer
@onready var collision_area: CollisionShape2D = $Area2D/CollisionShape2D

var count: int = 0

func _on_ready() -> void:
	timer.wait_time = delay;
	collision_area.scale.x = area_size_x;
	collision_area.scale.y = area_size_y;

func _on_timer_timeout() -> void:
	if active && count < quantity:
		var enemy = enemy_prefab.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = _random_position_in_area()
		count += 1

func _random_position_in_area() -> Vector2:
	var shape = collision_area.shape as RectangleShape2D
	var half = shape.size / 2.0
	var gt = collision_area.global_transform
	var center = gt.get_origin()
	var scalePos = gt.get_scale()
	var area_rect = Rect2(
		center - half * scalePos,
		shape.size * scalePos
	)

	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_rect = get_viewport_rect()
	var world_top_left = canvas_transform.affine_inverse() * screen_rect.position
	var world_bottom_right = canvas_transform.affine_inverse() * (screen_rect.position + screen_rect.size)
	var screen_world_rect = Rect2(world_top_left, world_bottom_right - world_top_left)

	var spawn_x = world_bottom_right.x
	var spawn_y = randf_range(
		clamp(area_rect.position.y, screen_world_rect.position.y, screen_world_rect.end.y),
		clamp(area_rect.end.y, screen_world_rect.position.y, screen_world_rect.end.y)
	)
	return Vector2(spawn_x, spawn_y)
