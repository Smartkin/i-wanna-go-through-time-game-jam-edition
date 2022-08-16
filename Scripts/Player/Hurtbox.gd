extends KinematicBody2D

signal hurt

func _physics_process(delta: float):
	var collision = move_and_collide(Vector2.ZERO, true, true, true)
	if (collision != null and collision.collider as Node != null):
		emit_signal("hurt", collision.collider as Node)
	
