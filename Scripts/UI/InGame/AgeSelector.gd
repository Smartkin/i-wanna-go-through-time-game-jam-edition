extends Control


func _enter_tree():
	if not WorldController.check_chip(Chip.CHIPS.ICE_AGE):
		get_node("%IceAge").disabled = true
	if not WorldController.check_chip(Chip.CHIPS.GUY_AGE):
		get_node("%GuyAge").disabled = true


func _on_IceAge_pressed():
	var btn := get_node("%IceAge")
	if WorldController.check_chip(btn.required_chip):
		WorldController.pause_physics()
		Util.change_scene_transition(btn.age_scene)


func _on_GuyAge_pressed():
	var btn := get_node("%GuyAge")
	if WorldController.check_chip(btn.required_chip):
		WorldController.pause_physics()
		Util.change_scene_transition(btn.age_scene)
