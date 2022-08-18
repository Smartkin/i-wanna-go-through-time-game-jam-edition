class_name Chip
extends Sprite

enum CHIPS {GUY_AGE, ICE_AGE, INVALID = -1}
export(CHIPS) var id = CHIPS.INVALID

func _on_scene_built() -> void:
	if WorldController.check_chip(id) and id != CHIPS.INVALID:
		queue_free()

func _on_Area2D_body_entered(body):
	if id == CHIPS.INVALID:
		return
	WorldController.save_chip(id)
#	WorldController.save_game()
	queue_free()
