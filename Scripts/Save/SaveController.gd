extends Node2D

onready var anim := $Machine
onready var anim_player := $AnimationPlayer


func _on_scene_built():
	if (WorldController.cur_save_data.save_id == get_instance_id()):
		anim.play("active")

func _process(delta: float):
	if (WorldController.cur_save_data.save_id != get_instance_id() and anim.animation != "activation"):
		anim.play("default")

func _reverse_gravity():
	$Sprite.scale.y = -1

func _normal_gravity():
	$Sprite.scale.y = 1


func _on_Sprite_animation_finished():
	if (anim.animation == "activation"):
		anim.play("active")
		WorldController.cur_save_data.save_id = get_instance_id()
		WorldController.save_game($SavePosition.global_position)


func _on_Area2D_activate():
	if (anim.animation != "active"):
		anim_player.play("display_text")
		anim.play("activation")
