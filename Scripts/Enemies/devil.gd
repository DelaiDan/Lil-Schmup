extends BaseEnemy
class_name Devil

@export var fire_delay: float = 0.1;
@export var speed: int = 100;
@export var score_value: int = 10;
@export var health: int = 2;

@onready var fire_delay_timer := $FireDelayTimer
@onready var animation_player := $AnimatedSprite2D/HitFlash

const PROJECTILE = preload("uid://cx8n2bbclus2c");

func _init() -> void:
	speed_base = speed;
	score_value_base = score_value;
	health_base = health;

func move(delta: float):
	translate(Vector2.LEFT * speed * delta)

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
