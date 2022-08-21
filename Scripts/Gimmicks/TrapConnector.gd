extends Area2D

func _on_connected_area_entered(body):
	set_deferred("monitoring", true)
