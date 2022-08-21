extends Sprite

export var wiggle_dist := 3.0
export var wiggle_speed := 400.0
var elapsed_time := 0.0
onready var moved_pos := position


func _ready() -> void:
	self_modulate.a = 0.0


func _process(delta: float) -> void:
	elapsed_time += delta
	position = moved_pos
	position.y += wiggle_dist * sin(deg2rad(wiggle_speed * elapsed_time))


func show_arrow() -> void:
	var tween := create_tween()
	tween.tween_property(self, "self_modulate:a", 1.0, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func hide_arrow() -> void:
	if (is_inside_tree()):
		var tween := create_tween()
		tween.tween_property(self, "self_modulate:a", 0.0, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
