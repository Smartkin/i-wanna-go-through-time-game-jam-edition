extends Node2D


func _ready():
	$IntroPlayer.play("Intro")

func teleport_kid():
	Util.change_scene_transition("res://Rooms/Title.tscn")



func _on_IntroPlayer_animation_finished(anim_name):
	teleport_kid()
