extends KinematicBody2D

signal hurt

func _physics_process(delta: float):
#	set_sync_to_physics(false)
	move_and_slide(Vector2.ZERO,  Vector2.UP)
	position = Vector2.ZERO
#	set_sync_to_physics(true)
	var col_cnt = get_slide_count()
	for i in range(col_cnt):
		var collision = get_slide_collision(i)
		if (collision.collider as Node != null):
			emit_signal("hurt", collision.collider as Node)
	
