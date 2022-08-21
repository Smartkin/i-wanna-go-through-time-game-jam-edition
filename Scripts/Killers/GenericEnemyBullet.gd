extends EnemyBulletBase

signal destroyed

var speed := Vector2.ZERO

func _physics_process(delta: float):
	if ($Sprite.animation == "destroy"):
		return
	position += speed * delta
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	if (col != null and not col.collider is KinematicBody2D):
		$Sprite.play("destroy")
		$CollisionShape2D.disabled = true

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "destroy"):
		emit_signal("destroyed")
		get_parent().queue_free()
