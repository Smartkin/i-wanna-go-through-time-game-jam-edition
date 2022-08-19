extends Area2D

export var prevent_exit := false

var camera_controller: Node2D = null
var area: RectangleShape2D = null

func _on_CameraArea_body_entered(body: Player):
	camera_controller = body.get_parent()
	camera_controller.lock_camera(global_position, Vector2(area.extents.x * 2, area.extents.y * 2))
	if (body.camera_areas.size() > 0):
		body.camera_areas.clear()
	body.add_camera_area(self)


func _on_CameraArea_body_exited(body: Player):
	if (prevent_exit or body.cur_state == Player.STATE.DEAD):
		return
	body.remove_camera_area(self)
	if (body.camera_areas.size() == 0):
		camera_controller.reset_camera()


func _on_CameraArea_child_entered_tree(node):
	area = get_child(0).shape
