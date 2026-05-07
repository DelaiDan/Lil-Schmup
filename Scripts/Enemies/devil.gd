extends BaseEnemy
class_name Devil

@export var fire_delay: float = 3;
@export var speed: int = 100;
@export var score_value: int = 10;
@export var health: int = 5;

@onready var fire_delay_timer := $FireDelayTimer
@onready var animation_player := $AnimatedSprite2D/HitFlash
@onready var movement_direction_multiplier: float = 0.5 if randi_range(0, 1) == 0 else -0.5

const PROJECTILE = preload("uid://cx8n2bbclus2c");

func _init() -> void:
	speed_base = speed;
	score_value_base = score_value;
	health_base = health;

func move(delta: float):
	var coordinates = return_world_coordinates();
	translate(Vector2.LEFT * speed * delta)
	
	position.y += sin(position.x * delta) * movement_direction_multiplier
	position.y = clamp(position.y, coordinates.top_left.y, coordinates.bottom_right.y)

	if global_position.x < coordinates.top_left.x:
		queue_free()

func shoot(delta: float):
	if fire_delay_timer.is_stopped():
		fire_delay_timer.start(fire_delay);
		if randi_range(0, 1) == 0:
			var new_projectile = PROJECTILE.instantiate();
			new_projectile.global_position = global_position;
			get_tree().current_scene.add_child(new_projectile);

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile"):
		hit(area, animation_player)
