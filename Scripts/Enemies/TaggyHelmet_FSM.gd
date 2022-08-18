extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	call_deferred("set_state", states.walk)


# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = ""
			parent.anim.play("walk")

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	return states.walk

