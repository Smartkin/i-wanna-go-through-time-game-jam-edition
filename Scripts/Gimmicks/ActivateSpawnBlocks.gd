extends Node2D



func _on_BossTrigger_body_entered(body):
	for c in get_children():
		c.activate()
