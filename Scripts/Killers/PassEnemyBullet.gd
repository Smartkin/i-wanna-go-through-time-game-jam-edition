extends EnemyBulletBase

signal destroyed

var speed := Vector2.ZERO

func _physics_process(delta: float):
	if ($Sprite.animation == "destroy"):
		return
	position += speed * delta

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "destroy"):
		emit_signal("destroyed")
		$CollisionShape2D.disabled = true
		get_parent().queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	$Sprite.play("destroy")
