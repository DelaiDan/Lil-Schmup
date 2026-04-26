extends BaseEnemy
class_name Skull

@export var fire_delay: float = 0.5;
@export var speed: int = 100
@export var score_value: int = 10
@export var health: int = 200
@export var margin_x: float = 60.0
@export var margin_y: float = 20.0

@onready var fire_delay_timer := $FireDelayTimer
@onready var animation_player := $AnimatedSprite2D/HitFlash

const PROJECTILE = preload("uid://cx8n2bbclus2c")
const EYEBALL = preload("uid://cr5ibjx0a6nu3")

enum State { ENTERING, PATROLLING }
var _state: State = State.ENTERING
var _patrol_dir: float = 1.0
var _target_x: float = 0.0

func _init() -> void:
	speed_base = speed
	score_value_base = score_value
	health_base = health
	invincible_base = true;

func _process(delta: float) -> void:
	var ct = get_viewport().get_canvas_transform()
	var sr = get_viewport_rect()
	var world_top = (ct.affine_inverse() * sr.position).y + margin_y
	var world_bottom = (ct.affine_inverse() * (sr.position + sr.size)).y - margin_y
	var world_right = (ct.affine_inverse() * (sr.position + sr.size)).x

	if _state == State.ENTERING:
		_target_x = world_right - margin_x
		translate(Vector2.LEFT * speed * delta)
		if global_position.x <= _target_x:
			global_position.x = _target_x
			await get_tree().create_timer(2).timeout
			invincible_base = false;
			_state = State.PATROLLING

	elif _state == State.PATROLLING:
		global_position.y += _patrol_dir * speed * delta
		if global_position.y >= world_bottom:
			global_position.y = world_bottom
			_patrol_dir = -1.0
		elif global_position.y <= world_top:
			global_position.y = world_top
			_patrol_dir = 1.0

	shoot(delta)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerProjectile"):
		hit(area, animation_player)

func shoot(delta: float):
	if fire_delay_timer.is_stopped():
		fire_delay_timer.start(fire_delay);
		var random = randi_range(0, 2);
		if random == 0:
			var new_projectile = PROJECTILE.instantiate();
			new_projectile.global_position = global_position;
			get_tree().current_scene.add_child(new_projectile);
		elif random == 1:
			var new_enemy = EYEBALL.instantiate()
			new_enemy.global_position = global_position;
			get_tree().current_scene.add_child(new_enemy)
