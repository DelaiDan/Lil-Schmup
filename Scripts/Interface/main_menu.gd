extends Control


func _on_start_pressed() -> void:
	#Level 1
	get_tree().change_scene_to_file("uid://cpreoocsbcqqc")
	
	#Level 2
	#get_tree().change_scene_to_file("uid://dlc2hscnha2r5")

func _on_quit_pressed() -> void:
	get_tree().quit();
