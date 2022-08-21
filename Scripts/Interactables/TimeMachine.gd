extends AnimatedSprite


var can_interact := false
var is_active := false
var age_selector := preload("res://Scenes/UI/InGame/AgeSelector.tscn")
var cur_selector: Node = null
onready var n_InteractArrow := $InteractArrow
onready var n_AnimationPlayer := $AnimationPlayer


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	WorldController.connect("game_got_paused", self, "_on_game_got_paused")
	is_active = WorldController.cur_save_data.chips.size() > 0
#	is_active = true

func _input(event: InputEvent):
	if not can_interact or not is_active:
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
	if is_active:
		n_InteractArrow.show_arrow()
	else:
		n_AnimationPlayer.play("show_needs_chip")


func _on_Area2D_body_exited(body):
	can_interact = false
	if is_active:
		if (not n_InteractArrow.is_queued_for_deletion()):
			n_InteractArrow.hide_arrow()
	else:
		n_AnimationPlayer.play_backwards("show_needs_chip")
