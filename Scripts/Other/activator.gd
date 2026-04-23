extends Node2D

signal activator_finished

@export var active: bool = false: set = _set_active
@export var delay: float

@onready var timer: Timer = $ActivationTimer

var _nodes: Array[Node] = []
var _current: int = 0
var _pending: int = 0

func _on_ready() -> void:
	timer.wait_time = delay
	timer.one_shot = true
	_nodes = get_children().filter(func(n): return not n is Timer)

func _set_active(value: bool) -> void:
	active = value
	if active and is_node_ready():
		_pending = _nodes.size()
		if _pending == 0:
			activator_finished.emit()
			return
		_activate_next()

func _activate_next() -> void:
	if _current >= _nodes.size():
		return

	var node = _nodes[_current]
	_current += 1

	if node.has_signal("wave_finished"):
		node.wave_finished.connect(_on_child_finished, CONNECT_ONE_SHOT)

	if "active" in node:
		node.active = true

	print("Activator: Node Started ", node.name, " [", _current, "/", _nodes.size(), "] ")

	if _current < _nodes.size():
		timer.start()

func _on_activation_timer_timeout() -> void:
	_activate_next()

func _on_child_finished() -> void:
	print("Activator: Node Finished [", _nodes.size() - _pending + 1, "/", _nodes.size(), "]")
	_pending -= 1
	if _pending == 0:
		activator_finished.emit()
