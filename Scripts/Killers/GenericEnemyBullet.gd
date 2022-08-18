extends EnemyBulletBase

signal destroyed

var speed := Vector2.ZERO

func _physics_process(delta: float):
	position += speed * delta
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	if (col != null):
		$Sprite.play("destroy")

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "destroy"):
		emit_signal("destroyed")
		get_parent().queue_free()