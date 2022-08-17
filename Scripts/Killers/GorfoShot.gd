extends EnemyBulletBase

var speed := Vector2.ZERO
var gravity = 4

func _physics_process(delta: float):
	position += speed * delta
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	speed.y += gravity
	if (col != null and not col.collider is KinematicBody2D):
		get_parent().queue_free()
