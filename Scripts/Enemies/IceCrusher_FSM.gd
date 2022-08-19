extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("idle", "_when_idle")
	_add_state("slide", "_when_slide")
	call_deferred("set_state", states.idle)

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.idle:
			condition = "player_in_sight"
			parent.wall_met = false
			parent.has_target = false
			parent.anim.play("default")
		states.slide:
			condition = "met_wall"

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for when the state is transitioning to a new one
func _get_transition_state() -> State:
	match state:
		states.idle:
			return states.slide
		states.slide:
			return states.idle
	return null
