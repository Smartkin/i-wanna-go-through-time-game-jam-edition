extends Control



func _on_IceAge_pressed():
	var btn := get_node("%IceAge")
	if WorldController.check_item(btn.required_chip):
		WorldController.pause_physics()
		get_tree().change_scene(btn.age_scene)
