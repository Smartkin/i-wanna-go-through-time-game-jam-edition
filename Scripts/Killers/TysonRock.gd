extends EnemyBulletBase

signal destroyed

var speed := Vector2.ZERO
var gravity := 0.0
var is_hit := false
onready var rotation_spd := rand_range(-200, 200)

func _physics_process(delta: float):
	if ($Smash.playing):
		return
	position += speed * delta
	speed.y += gravity
	rotation_degrees += rotation_spd * delta
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	if (col != null and not col.collider is KinematicBody2D and !is_hit):
		destroy()
		$CollisionShape2D.disabled = true


func destroy():
	is_hit = true
	$Sprite.visible = false
	emit_signal("destroyed")
	$SmokeParticles.emitting = true
	$RockParticles.emitting = true
	$Smash.pitch_scale = rand_range(0.9, 1.2)
	$Smash.play()


func _on_AudioStreamPlayer_finished() -> void:
	get_parent().queue_free()


func _on_EnableCollisions_timeout() -> void:
	$CollisionShape2D.disabled = false
