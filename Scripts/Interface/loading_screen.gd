extends Control

@onready var progress_bar := $ProgressBar

var next_scene: String = Global.next_scene

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene);

func _process(delta: float) -> void:
	var progress = [];
	ResourceLoader.load_threaded_get_status(next_scene, progress);
	progress_bar.value = progress[0]*100
	
	if progress[0] == 1:
		var scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(scene)

func _set_next_scene(scene) -> void:
	next_scene = str(scene);
