extends Control

@onready var transition := $CanvasLayer/SceneTransition

func _on_start_pressed() -> void:
	transition._transition_to_loading()

func _on_quit_pressed() -> void:
	get_tree().quit();
