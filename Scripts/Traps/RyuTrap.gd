extends Node2D

export (String) var trap = "ComeOutGround"


func activate():
	$Trap.play(trap)


func _on_Area2D_body_entered(body):
	activate()
	$Area2D.queue_free()
