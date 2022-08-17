extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	_add_state("slide", "_when_slide")
	call_deferred("set_state", states.walk)


# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = ""
			parent.anim.play("walk")
			parent.speed = parent.init_speed
			parent.get_node("SlideWait").stop()
		states.slide:
			condition = "_no_player_in_sight"
			parent.anim.play("slide")

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.walk:
			return states.walk
		states.slide:
			return states.walk
	return null


func _on_ProximityCheck_body_entered(body: Player):
	if (body == null):
		return
	if (state != states.slide):
		set_state(states.slide)
		parent.track_player = body



func _on_ProximityCheck_body_exited(body: Player):
	if (body == null):
		return
	parent.track_player = null
