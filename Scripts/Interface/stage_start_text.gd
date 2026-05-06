extends Control

signal stage_intro_finished
signal stage_clear_finished

const SLIDE_DURATION := 0.4
const HOLD_DURATION := 1.5
const START_HOLD := 1.0
const SLIDE_DIST := 640.0

@onready var _stage_name: Label = $StageName
@onready var _stage_start: Label = $StageStart
@onready var _stage_clear: Label = $StageClear

func _ready() -> void:
	_stage_name.visible = false
	_stage_start.visible = false
	_stage_clear.visible = false

func show_stage_start(stage_name: String) -> void:
	_stage_name.text = "STAGE " + stage_name
	await _slide_in_out(_stage_name)
	await _slide_in_out(_stage_start)
	stage_intro_finished.emit()

func show_stage_clear() -> void:
	await _slide_in_out(_stage_clear)
	stage_clear_finished.emit()

func _slide_in_out(label: Label) -> void:
	label.visible = true
	var set_shift := func(shift: float) -> void:
		label.offset_left = shift
		label.offset_right = shift
	var tween := create_tween()
	tween.tween_method(set_shift, SLIDE_DIST, 0.0, SLIDE_DURATION) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(HOLD_DURATION)
	tween.tween_method(set_shift, 0.0, -SLIDE_DIST, SLIDE_DURATION) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	label.offset_left = 0.0
	label.offset_right = 0.0
	label.visible = false

func _fade_in_out(label: Label) -> void:
	label.modulate.a = 0.0
	label.visible = true
	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.2)
	tween.tween_interval(START_HOLD)
	tween.tween_property(label, "modulate:a", 0.0, 0.3)
	await tween.finished
	label.modulate.a = 1.0
	label.visible = false
