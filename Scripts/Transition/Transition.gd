extends Node2D

signal transition_finished

enum STATE {
	FROM,
	TO
}

export(float, 0.1, 10.0) var dur := 1.0
export(float, 0.0, 1.0) var ramp := 0.05
export(Color) var halo_color := Color8(0, 0, 0)
export(Color) var trans_color := Color8(255, 255, 255)
export(String, FILE, "*.png") var mask

var _t := 0.0
var _state = STATE.FROM
var _time := 0.0
var _trans := Tween.TRANS_CUBIC


func _ready() -> void:
	if _state == STATE.FROM:
		var tween := create_tween()
		tween.tween_property(self, "_t", 1.0, dur).set_ease(Tween.EASE_OUT).set_trans(_trans)
	else:
		var tween := create_tween()
		tween.tween_property(self, "_t", 0.0, dur).set_ease(Tween.EASE_IN).set_trans(_trans)
	$CanvasLayer/ColorRect.material = preload("res://Shaders/Transition.tres")
#	print(material)
	$CanvasLayer/ColorRect.material.set_shader_param("after", trans_color)
	$CanvasLayer/ColorRect.material.set_shader_param("t", _t)
	$CanvasLayer/ColorRect.material.set_shader_param("halo_color", halo_color)
	$CanvasLayer/ColorRect.material.set_shader_param("ramp", ramp)
	$CanvasLayer/ColorRect.material.set_shader_param("mask", load(mask))


func _exit_tree():
	WorldController.free_transition()


func set_state(new_state) -> void:
	_state = new_state
	if _state == STATE.FROM:
		var tween := create_tween()
		tween.tween_property(self, "_t", 1.0, dur).set_ease(Tween.EASE_OUT).set_trans(_trans)
	else:
		var tween := create_tween()
		tween.tween_property(self, "_t", 0.0, dur).set_ease(Tween.EASE_IN).set_trans(_trans)

func set_time(new_time: float) -> void:
	_t = new_time
	

func _process(delta: float):
	match _state:
		STATE.FROM:
			if _t >= 1.0:
				emit_signal("transition_finished")
				set_state(STATE.TO)
		STATE.TO:
			if _t <= 0.0:
				queue_free()
	$CanvasLayer/ColorRect.material.set_shader_param("t", _t)
