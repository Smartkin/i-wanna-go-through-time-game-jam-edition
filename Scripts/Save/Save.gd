extends Area2D

signal activate

func _on_Area2D_body_entered(body: Player) -> void:
	if (body != null):
		emit_signal("activate")

func _on_Area2D_body_exited(body: Player) -> void:
	if (body == null):
		return
	body.can_save = false
	body.save_point = null
