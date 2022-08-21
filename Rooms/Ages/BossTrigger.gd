extends Area2D

func _ready():
	if (WorldController.check_chip(Chip.CHIPS.ICE_AGE)):
		$CollisionShape2D.disabled = true
