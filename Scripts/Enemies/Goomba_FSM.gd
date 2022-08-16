extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	_add_state("idle", "_when_idle")
	call_deferred("set_state", states.walk)


# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = "_stuck"
		states.idle:
			condition = "_not_stuck"

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.walk:
			return states.idle
		states.idle:
			return states.walk
	return null
