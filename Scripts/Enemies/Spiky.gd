extends KillerBase

export var ease_dur := 1.0 
export var mirror_path := false

onready var n_FollowPath := $FollowPath
onready var starting_pos := global_position 
var current_node := 0
var node_increment := 1
var point_count := 0


func _ready() -> void:
	point_count = n_FollowPath.curve.get_point_count()
	if point_count > 0:
		goto_next_path_node()


func goto_next_path_node() -> void:	
	if mirror_path:
		current_node += node_increment
		if current_node == point_count:
			current_node = point_count - 1
			node_increment *= -1
		elif current_node < 0:
			current_node = 0
			node_increment *= -1
	else:
		current_node = (current_node+1) % point_count
	
	var point_pos : Vector2 = n_FollowPath.curve.get_point_position(current_node)
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", starting_pos + point_pos, ease_dur)
	print(point_pos)
	
	yield(tween, "finished")
	goto_next_path_node()
