class_name StateMachine
extends Node

var states := {} # Map of states
var state: State = null setget set_state
var prev_state: State = null
var condition: String = "" # Predicate for state switching

onready var parent := get_parent()

func _physics_process(delta):
	if state != null:
		# Switch state if the condition is met
		if condition != "" and parent.call(condition, delta):
			set_state(_get_transition_state())
		
		# Run the callback that's attached to the state
		if state.callback != "":
			parent.call(state.callback, delta, state.binds)


func set_state(new_state: State):
	prev_state = state
	if state != null:
		_exit_state(state, new_state)
	state = new_state
	if state != null:
		_enter_state(new_state, prev_state)


func _enter_state(new_state: State, old_state: State):
	pass


func _exit_state(old_state: State, new_state: State):
	pass


func _get_transition_state() -> State:
	return null


func _add_state(state_name: String, callback: String, binds: Array = []):
	states[state_name] = State.new()
	states[state_name].callback = callback
	states[state_name].binds = binds

func reset():
	states.clear()
	state = null
	prev_state = null
	condition = ""
	_ready()

class State:
	var callback := ""
	var binds := []
