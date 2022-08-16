extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("idle", "_when_idle")
	_add_state("die", "_when_die")
	call_deferred("set_state", states.idle)

func _when_idle(delta: float, binds: Array):
	pass

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.idle:
			condition = "_jumped_on"
		states.die:
			condition = ""
			parent.get_node("Hitbox").monitoring = false
			parent.get_node("Hurtbox").monitoring = false
			parent.get_node("Jumpbox").monitoring = false
			parent.anim.play("bounced")

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.idle:
			return states.die
	return null
