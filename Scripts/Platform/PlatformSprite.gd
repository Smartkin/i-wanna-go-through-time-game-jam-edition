tool
extends Sprite


func _ready():
	get_material().set_shader_param("scale", scale)
	set_notify_transform(true)


func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		get_material().set_shader_param("scale", scale)
