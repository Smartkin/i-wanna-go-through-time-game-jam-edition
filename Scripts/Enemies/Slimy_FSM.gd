extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	_add_state("jump", "_when_jump")
	call_deferred("set_state", states.walk)


# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = "_stuck"
			parent.anim.play("walk")
			parent.speed.x = parent.init_spd.x
			parent.get_node("JumpWait").stop()
		states.jump:
			condition = ""
			parent.speed.y = parent.jump_force.y

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.walk:
			return states.walk
		states.jump:
			return states.walk
	return null


func _on_ProximityCheck_body_entered(body: Player):
	if (body == null):
		return
	if (state != states.jump):
		set_state(states.jump)
		parent.track_player = body


func _on_ProximityCheck_body_exited(body: Player):
	if (body == null):
		return
	set_state(states.walk)
	parent.track_player = null
