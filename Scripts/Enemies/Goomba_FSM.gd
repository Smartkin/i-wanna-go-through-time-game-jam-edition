extends StateMachine

# Add all the states object can be at
func _ready():
	_add_state("walk", "_when_walk")
	_add_state("idle", "_when_idle")
	_add_state("bounce", "_when_bounce")
	call_deferred("set_state", states.walk)


# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	match new_state:
		states.walk:
			condition = "_stuck"
			parent.anim.play("walk")
		states.idle:
			condition = "_not_stuck"
		states.bounce:
			condition = ""

# Write the logic for getting transitions to new states
func _get_transition_state() -> State:
	match state:
		states.walk:
			if parent._player_above:
				return states.bounce
			return states.idle
		states.idle:
			return states.walk
		states.bounce:
			return states.walk
	return null


func _on_Sprite_animation_finished():
	if parent.anim.animation == "bounced":
		parent.anim.stop()
		parent.anim.frame = parent.anim.frames.get_frame_count("bounced") - 1
		parent.get_node("StunTimer").start()


func _on_StunTimer_timeout():
	set_state(states.walk)
