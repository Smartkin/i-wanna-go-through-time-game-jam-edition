extends Sprite


var can_interact := false
var age_selector := preload("res://Objects/UI/InGame/AgeSelector.tscn")
var cur_selector: Node = null

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	WorldController.connect("game_got_paused", self, "_on_game_got_paused")

func _input(event: InputEvent):
	if not can_interact:
		return
	if event.is_action_pressed("up") and cur_selector == null:
		cur_selector = age_selector.instance()
		get_node("%SelectorLayer").add_child(cur_selector)
		WorldController.pause_physics()
	elif event.is_action_pressed("shoot") and cur_selector != null:
		cur_selector.queue_free()
		cur_selector = null
		WorldController.pause_physics()


func _on_game_got_paused(paused: bool):
	pause_mode = PAUSE_MODE_PROCESS
	if paused:
		pause_mode = PAUSE_MODE_STOP

func _on_Area2D_body_entered(body):
	can_interact = true


func _on_Area2D_body_exited(body):
	can_interact = false
