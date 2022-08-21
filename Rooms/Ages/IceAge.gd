extends Node2D

onready var lbl_pos: Vector2 = $Label.rect_position

func _process(delta):
	$Label.rect_position = Vector2(lbl_pos.x, lbl_pos.y + sin(Time.get_ticks_msec() / 500.0) * 15.0)
