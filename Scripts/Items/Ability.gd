class_name Ability
extends Sprite


enum ABILITIES {
	DOUBLE_JUMP,
	SHOOT,
	DOT_KID,
	DASH,
	HEALTH_1,
	HEALTH_2,
	HEALTH_3,
	HEALTH_4,
	HEALTH_5,
	INVALID = -1
}
export(ABILITIES) var id = ABILITIES.INVALID

func _on_scene_built() -> void:
	if WorldController.check_item(id) and id != -1:
		queue_free()

func _on_Area2D_body_entered(body):
	if id == -1:
		return
	WorldController.save_item(id)
	WorldController.save_game()
	queue_free()
