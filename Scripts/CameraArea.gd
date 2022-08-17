extends Area2D

var camera_controller: Node2D = null
onready var area: RectangleShape2D = get_node("CollisionShape2D").shape

func _on_CameraArea_body_entered(body: Player):
	camera_controller = body.get_parent()
	camera_controller.lock_camera(global_position, Vector2(area.extents.x * 2, area.extents.y * 2))


func _on_CameraArea_body_exited(body: Player):
	camera_controller.reset_camera()
