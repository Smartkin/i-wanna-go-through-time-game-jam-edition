extends Node2D

func _ready():
	$IntroPlayer.play("PlayerWalk")
	$"%Skip".text = "Press " + InputMap.get_action_list("skip")[0].as_text() + " to skip"
	var fade_tween = create_tween()
	fade_tween.tween_property($"%Skip", "self_modulate", Color8(255, 255, 255, 0), 5.0)

func _input(event: InputEvent):
	if (event.is_action_pressed("skip")):
		teleport_kid()

func teleport_kid():
	Util.change_scene_transition("res://Rooms/Title.tscn")

