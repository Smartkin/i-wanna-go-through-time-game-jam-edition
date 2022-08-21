extends Sprite

var can_interact := false
var player: Player = null

func _input(event: InputEvent):
	if not can_interact:
		return
	if event.is_action_pressed("up"):
		player._switch_state(Player.STATE.CUTSCENE)
		(yield(WorldController.do_transition(1.0), "transition_finished"))
		var time_machine = get_tree().current_scene.find_node("TimeMachine")
		player.global_position = Vector2(time_machine.global_position.x, time_machine.global_position.y - 16)
		player._revert_state()
		can_interact = false

func _on_Area2D_body_entered(body: Player):
	player = body
	can_interact = true
	$InteractArrow.show_arrow()


func _on_Area2D_body_exited(body: Player):
	player = null
	can_interact = false
	$InteractArrow.hide_arrow()
