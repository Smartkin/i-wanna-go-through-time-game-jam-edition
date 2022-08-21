tool
extends Area2D

export var prevent_exit := false

var camera_controller: Node2D = null
var area: RectangleShape2D = null
var notifier: VisibilityNotifier2D = null
var enemy_to_manip := []


func _on_CameraArea_body_entered(body: KinematicBody2D):
	if not body is Player:
		enemy_to_manip.append(weakref(body))
		return
	camera_controller = body.get_parent()
	camera_controller.lock_camera(global_position, Vector2(area.extents.x * 2, area.extents.y * 2))
#	if (body.camera_areas.size() > 0):
#		body.camera_areas.clear()
	body.add_camera_area(self)

func _on_CameraArea_body_exited(body: KinematicBody2D):
	if not body is Player:
		return
	if (prevent_exit or body.cur_state == Player.STATE.DEAD):
		return
	body.remove_camera_area(self)
	if (body.camera_areas.size() == 0):
		camera_controller.reset_camera()
#	else:
#		var old_area = body.camera_areas[0]
#		camera_controller.lock_camera(old_area.global_position, Vector2(area.extents.x * 2, area.extents.y * 2))

func _on_CameraArea_child_entered_tree(node):
	area = get_child(0).shape

func kill_enemies():
	for e in enemy_to_manip:
		if (e.get_ref() and e.get_ref().has_method("_disable")):
			e.get_ref()._disable()

func respawn_enemies():
	for e in enemy_to_manip:
		if (e.get_ref() and e.get_ref().has_method("_respawn")):
			e.get_ref()._respawn()
