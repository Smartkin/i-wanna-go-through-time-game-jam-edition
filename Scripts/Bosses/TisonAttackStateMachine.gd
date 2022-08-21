extends StateMachine

var attack_shuffle := []
var attacks := []

# Add all the states object can be at
func _ready():
	_add_state("punch", "", "punch")
	_add_state("uppercut", "", "uppercut")
	_add_state("lunge", "", "lunge")
	for a in states.keys():
		attacks.append(a)
	condition = "attack_finished"
	attack_shuffle = attacks.duplicate()
	attack_shuffle.shuffle()
	starting_state = states.get(attack_shuffle.pop_front())

# Write the logic for when new state is entered
func _enter_state(new_state: State, old_state: State):
	pass

# Write the logic for when the current state is exited
func _exit_state(old_state: State, new_state: State):
	pass

# Write the logic for when the state is transitioning to a new one
func _get_transition_state() -> State:
	if (attack_shuffle.size() == 0):
		attack_shuffle = attacks.duplicate()
		attack_shuffle.shuffle()
	return states.get(attack_shuffle.pop_front())
