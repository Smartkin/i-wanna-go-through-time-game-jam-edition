class_name Chip
extends Sprite

enum CHIPS {TEST, ICE_AGE, INVALID = -1}
export(CHIPS) var id = CHIPS.INVALID

func _on_scene_built() -> void:
	if WorldController.check_item(id) and id != -1:
		queue_free()

func _on_Area2D_body_entered(body):
	if id == -1:
		return
	WorldController.save_item(id)
	WorldController.save_game()
	queue_free()
