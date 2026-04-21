extends Node2D

signal next_stage(node: Node, stage: int)

@export var level_stage: int = 0

@onready var stages: Node2D = $Enemies

func _ready() -> void:
	_activate_stage(level_stage)

func _activate_stage(index: int) -> void:
	var children = stages.get_children()
	if index >= children.size():
		return

	var stage_node = children[index]

	if stage_node.has_signal("wave_finished"):
		stage_node.wave_finished.connect(_on_wave_finished, CONNECT_ONE_SHOT)

	if "active" in stage_node:
		stage_node.active = true

	next_stage.emit(stage_node, index)
	print("Wave Started")

func _on_wave_finished() -> void:
	print("Wave Finished")
	level_stage += 1
	_activate_stage(level_stage)
