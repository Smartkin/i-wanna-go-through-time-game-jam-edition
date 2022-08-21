extends KinematicBody2D

export var ease_dur := 1.0 
export var mirror_path := false

onready var n_FollowPath := $FollowPath
var current_node := 0
var node_increment := 1
var path_nodes := []


func _ready() -> void:
	path_nodes = n_FollowPath.curve.get_baked_points()
	if path_nodes.size() > 0:
		goto_next_path_node()


func goto_next_path_node() -> void:
	if mirror_path:
		current_node += node_increment
		if current_node == path_nodes.size():
			current_node = path_nodes.size() - 1
			node_increment *= -1
		elif current_node < 0:
			current_node = 0
			node_increment *= -1
	else:
		current_node = (current_node+1) % path_nodes.size()
	
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", path_nodes[current_node], ease_dur)
	print(path_nodes)
	
	yield(tween, "finished")
	goto_next_path_node()
