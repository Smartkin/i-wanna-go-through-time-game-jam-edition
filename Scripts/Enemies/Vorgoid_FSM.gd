extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("fly", "_when_fly")
	_add_state("return", "_when_return")
	_add_state("chase", "_when_chase")
	call_deferred("set_state", states.fly)

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.fly:
			condition = ""
		states.chase:
			condition = "_no_player_in_sight"
		states.return:
			condition = "_came_home"
			var path = Navigation2DServer.map_get_path(parent.get_agent_rid(), parent.global_position, parent.home, true)
			path.remove(0)
			parent.navigate(path)

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	match old_state:
		states.fly:
			parent.at_home = false
			parent.home = parent.global_position
		states.return:
			if (new_state == states.fly):
				parent.global_position = parent.home

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.fly:
			return states.chase
		states.chase:
			return states.return
		states.return:
			return states.fly
	return null

func _on_Vorgoid_player_spotted():
	set_state(states.chase)


func _on_Vorgoid_died():
	queue_free()
