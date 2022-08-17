extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	_add_state("spit", "_when_spit")
	call_deferred("set_state", states.walk)

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = ""
			parent.anim.play("walk")
			parent.get_node("Walking").start()
		states.spit:
			condition = "_no_player_in_sight"
			parent.anim.play("spit")

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.walk:
			return states.spit
		states.spit:
			return states.walk
	return null


func _on_Gorfo_player_spotted():
	set_state(states.spit)
