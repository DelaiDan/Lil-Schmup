extends ColorRect

@onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play_backwards("Fade");

func _transition_to(scene) -> void:
	anim_player.play("Fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(scene)
