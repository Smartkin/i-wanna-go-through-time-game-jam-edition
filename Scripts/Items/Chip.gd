class_name Chip
extends AnimatedSprite

const ability_description_scene := preload("res://Scenes/Items/ChipGrabbed.tscn")

enum CHIPS {GUY_AGE, ICE_AGE, INVALID = -1}
export(CHIPS) var id = CHIPS.INVALID

func _on_scene_built() -> void:
	if WorldController.check_chip(id) and id != CHIPS.INVALID:
		queue_free()

func _on_Area2D_body_entered(body):
	if id == CHIPS.INVALID:
		return
	WorldController.save_chip(id)
	
	var ability_ui := ability_description_scene.instance()
	get_tree().current_scene.add_child(ability_ui)
	queue_free()
