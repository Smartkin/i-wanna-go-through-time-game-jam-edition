extends Node2D

export (String) var trap = "ComeOutGround"

const AFTER_IMAGE := preload("res://Scenes/AfterImage.tscn")

var do_trail := false

onready var anim := $KillerBase/AnimatedSprite

func activate():
	$Trap.play(trap)
	yield($Trap, "animation_finished")
	stop_after_image()


func _on_Area2D_body_entered(body):
	activate()
	create_after_image()

func create_after_image():
	if (do_trail):
		return
	
	do_trail = true
	while do_trail:
		var trail: Sprite = AFTER_IMAGE.instance()
		trail.scale = anim.scale
		trail.texture = anim.frames.get_frame(anim.animation, anim.frame)
		trail.global_position = anim.global_position
		trail.rotation_degrees = $KillerBase.rotation_degrees
		print(rotation_degrees)
		get_tree().current_scene.add_child(trail)
		(yield(get_tree().create_timer(0.1), "timeout"))

func stop_after_image():
	do_trail = false
