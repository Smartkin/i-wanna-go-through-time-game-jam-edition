extends EnemyBulletBase

signal destroyed
const AFTER_IMAGE := preload("res://Scenes/AfterImage.tscn")

var speed := Vector2.ZERO
var gravity := 0.0

func _physics_process(delta: float):
	if ($Sprite.animation == "destroy"):
		return
	position += speed * delta
	speed.y += gravity

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "destroy"):
		emit_signal("destroyed")
		$CollisionShape2D.disabled = true
		get_parent().queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	$Sprite.play("destroy")


func _on_AfterImage_timeout() -> void:
	var trail: Sprite = AFTER_IMAGE.instance()
	trail.dur = 1.0
	trail.scale = scale
	trail.target_scale = Vector2.ZERO
	trail.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	trail.texture = $Sprite.frames.get_frame($Sprite.animation, $Sprite.frame)
	trail.global_position = $Sprite.global_position
	get_tree().current_scene.add_child(trail)
