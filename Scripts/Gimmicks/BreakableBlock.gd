extends StaticBody2D

onready var n_CollisionShape := $CollisionShape2D
onready var n_AnimatedSprite := $AnimatedSprite
onready var n_SmokeParticles := $SmokeParticles
onready var n_AnimatedPlayer := $AnimationPlayer


func break_block() -> void:
	n_AnimatedSprite.play("break")


func destroy() -> void:
	n_AnimatedSprite.visible = false
	n_CollisionShape.disabled = true
	n_SmokeParticles.emitting = true
	n_AnimatedPlayer.play("chunks_scatter")
	$Break.pitch_scale = rand_range(0.8, 1.2)
	$Break.play()
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	destroy()
	n_AnimatedSprite.playing = false
