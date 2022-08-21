extends StaticBody2D

onready var n_AnimationPlayer := $AnimationPlayer


func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false


func activate():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
	n_AnimationPlayer.play("appear")


func deactivate():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	n_AnimationPlayer.play_backwards("appear")
