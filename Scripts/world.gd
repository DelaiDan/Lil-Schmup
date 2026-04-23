extends Node2D

signal next_stage(node: Node, stage: int)

@export var level_stage: int = 0
@export var wave_stage: int = 0
var current_stage: Node = null

@onready var stages: Node2D = $Stages

func _ready() -> void:
	_activate_stage(level_stage)

func _activate_stage(index: int) -> void:
	var children = stages.get_children()
	if index >= children.size():
		return

	current_stage = children[index]
	wave_stage = 0
	print("Stage Started")
	_next_wave(wave_stage)
	
func _next_wave(index: int) -> void:
	var children = current_stage.get_children()
	if index >= children.size():
		print("Stage Finished")
		level_stage += 1
		_activate_stage(level_stage)
		return

	var stage_node = children[index]

	if stage_node.has_signal("wave_finished"):
		stage_node.wave_finished.connect(_on_wave_finished, CONNECT_ONE_SHOT)
	elif stage_node.has_signal("activator_finished"):
		stage_node.activator_finished.connect(_on_activator_finished, CONNECT_ONE_SHOT)

	if "active" in stage_node:
		print("Node ", stage_node.name ," Started")
		stage_node.active = true

	next_stage.emit(stage_node, index)

func _on_wave_finished() -> void:
	print("Node Finished")
	wave_stage += 1
	_next_wave(wave_stage)
	
func _on_activator_finished() -> void:
	print("Stage Finished")
	level_stage += 1
	_activate_stage(level_stage)
