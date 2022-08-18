extends StateMachine

# Add all the states object can be at
func _ready():
	# _add_state("idle", "_when_idle")
	pass

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	pass

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for when the state is transitioning to a new one
func _get_transition_state() -> State:
	return null
