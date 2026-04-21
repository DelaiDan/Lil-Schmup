extends CharacterBody2D
class_name Player

@export var health: int = 10
@export var speed: int = 100

const BAT = preload("uid://jrdvbcc73muc");
const ARROW = preload("uid://tk0vy7q7q2yd");

const EXPLOSION = preload("uid://cq7d5u22l8liu");

@onready var progress_bar := $CanvasLayer/Health/ProgressBar
@onready var fire_delay_timer := $FireDelayTimer
@onready var invincibility_timer := $InvincibilityTimer

var invincible = false;
var current_weapon: PackedScene = null
var fire_delay: float = 0.1

func _ready():
	progress_bar.max_value = health
	progress_bar.value = health
	set_current_weapon(BAT);

func _process(delta: float) -> void:
	var move = Input.get_vector("left", "right", "up", "down");
	if move:
		velocity = move * speed;
	else:
		velocity = Vector2.ZERO;
	
	move_and_slide();
	_clamp_to_camera();
	_check_invincibility();

	if Input.is_action_pressed("shoot") and fire_delay_timer.is_stopped():
		shoot();
		
func shoot():
	fire_delay_timer.start(fire_delay);
	var new_projectile = current_weapon.instantiate();
	new_projectile.global_position = global_position;
	get_tree().current_scene.add_child(new_projectile);

func _clamp_to_camera() -> void:
	var camera = get_viewport().get_canvas_transform()
	var screen_rect = get_viewport_rect()
	var world_top_left = camera.affine_inverse() * screen_rect.position
	var world_bottom_right = camera.affine_inverse() * (screen_rect.position + screen_rect.size)
	global_position.x = clamp(global_position.x, world_top_left.x, world_bottom_right.x)
	global_position.y = clamp(global_position.y, world_top_left.y, world_bottom_right.y)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") or area.is_in_group("EnemyProjectile"):
		hit(area);
	
	if area.is_in_group("HealthUp"):
		health += 3
		area.queue_free()
		if health > progress_bar.max_value:
			health = progress_bar.max_value
		progress_bar.value = health
		addScore(50);
		
	if area.is_in_group("ArrowPickup"):
		set_current_weapon(ARROW)
		area.queue_free()

func _set_invincibility(value) -> void:
	if value:
		invincibility_timer.start(0.5)
	invincible = value

func _check_invincibility() -> void:
	if invincibility_timer.is_stopped():
		invincible = false;

func addScore(value) -> void:
	Global.score += value
	
func hit(area: Area2D) -> void:
	blink();
	
	if(area.has_method('explode')):
		area.explode()
	else:
		area.queue_free()

	if !invincible:
		health -= 5
		if health <= 0:
			Global.lifes -= 1;
			Global.score = clampi(Global.score-150, 0, Global.score);
			set_current_weapon(BAT);
			health = 10;
			if Global.lifes < 0:
				get_tree().reload_current_scene();
				Global.lifes = 3;
				Global.score = 0;
				#get_tree().change_scene_to_file("gameover.tsc")
		progress_bar.value = health
		_set_invincibility(true);
		
func blink():
	var tween = create_tween().set_loops(4)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.1)
	
func set_current_weapon(weapon: PackedScene):
	current_weapon = weapon;
	var weapon_node = weapon.instantiate();
	fire_delay = weapon_node.call("get_fire_delay");
	addScore(weapon_node.call("get_pickup_score"));
