extends BaseEnemy
class_name Eyeball

@export var speed: int = 200;
@export var score_value: int = 10;
@export var health: int = 4;

@onready var animation_player := $AnimatedSprite2D/HitFlash

const PROJECTILE = preload("uid://cx8n2bbclus2c");

func _init() -> void:
	speed_base = speed;
	score_value_base = score_value;
	health_base = health;

func move(delta: float):
	translate(Vector2.LEFT * speed * delta)

func shoot(delta: float):
	pass;

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile"):
		hit(area, animation_player)
