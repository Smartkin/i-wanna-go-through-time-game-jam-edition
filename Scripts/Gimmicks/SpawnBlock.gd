extends StaticBody2D

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false

func activate():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
