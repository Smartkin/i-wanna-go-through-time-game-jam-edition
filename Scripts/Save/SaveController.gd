extends Node2D

onready var anim := $Machine
onready var anim_player := $AnimationPlayer
var rand := RandomNumberGenerator.new()

func _ready():
	if (WorldController.cur_save_data.save_id == get_id()):
		anim.play("active")
	$Area2D.monitoring = true

func _process(delta: float):
	if (WorldController.cur_save_data.save_id != get_id() and anim.animation != "activation"):
		anim.play("default")

func get_id() -> int:
	var pos := global_position
	var scene := get_tree().current_scene.name
	return hash(scene + String(pos) + name)

func _reverse_gravity():
	$Sprite.scale.y = -1

func _normal_gravity():
	$Sprite.scale.y = 1


func _on_Sprite_animation_finished():
	if (anim.animation == "activation"):
		anim.play("active")


func _on_Area2D_activate():
	if (anim.animation != "active"):
		anim_player.play("display_text")
		anim.play("activation")
		WorldController.cur_save_data.save_id = get_id()
		WorldController.save_game($SavePosition.global_position)
		$SavedGame.play()
