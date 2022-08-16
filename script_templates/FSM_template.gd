extends StateMachine

# Add all the states object can be at
func _ready():
	# _add_state("idle", "_when_idle")
	pass

#func _when_idle(delta: float, binds: Array)%VOID_RETURN%:
#	pass

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	pass

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for getting transitions to new states
func _get_state() -> State:
	return null
