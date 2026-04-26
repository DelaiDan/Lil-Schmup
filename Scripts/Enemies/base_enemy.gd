extends Area2D
class_name BaseEnemy

var speed_base: int = 100;
var score_value_base: int = 10;
var health_base: int = 10;
var invincible_base = false;
var animation: AnimationPlayer;

var player: Player = Player.new();

const HEALTH_UP = preload("uid://dy16nxjms2p84");
const ARROW_PICKUP = preload("uid://dxjwg4qk52ghd");

const EXPLOSION = preload("uid://cq7d5u22l8liu");

func _process(delta: float) -> void:
	var canvas_transform = get_viewport().get_canvas_transform()
	var screen_rect = get_viewport_rect()
	var world_top_left = canvas_transform.affine_inverse() * screen_rect.position
	var world_bottom_right = canvas_transform.affine_inverse() * (screen_rect.position + screen_rect.size)
	
	move(delta);
	shoot(delta);
	
	position.y += sin(position.x * delta) * 0.5
	position.y = clamp(position.y, world_top_left.y, world_bottom_right.y)

	if global_position.x < world_top_left.x:
		queue_free()

func hit(area: Area2D, animation_player: AnimationPlayer) -> void:
	if area.is_in_group("PlayerProjectile"):
		if !invincible_base:
			health_base -= area.get_damage();
			if health_base > 0:
				blink(animation_player);
			elif health_base <= 0:
				explode();
				dropPowerup();
				player.addScore(score_value_base);
		area.queue_free();

func explode():
	var pos = global_position
	var explosion = EXPLOSION.instantiate()
	get_tree().current_scene.call_deferred('add_child', explosion)
	explosion.global_position = pos
	queue_free()

func blink(animation_player: AnimationPlayer):
	if(animation_player.has_method("play")):
		animation_player.play("hitflash");

func dropPowerup():
	var pos = global_position
	var random = randi_range(0, 10)
	if random == 0:
		var powerup = HEALTH_UP.instantiate()
		get_tree().current_scene.call_deferred('add_child', powerup)
		powerup.global_position = pos

	if random == 1:
		var powerup = ARROW_PICKUP.instantiate()
		get_tree().current_scene.call_deferred('add_child', powerup)
		powerup.global_position = pos

func move(delta: float) -> void:
	pass;
	
func shoot(delta: float) -> void:
	pass;
