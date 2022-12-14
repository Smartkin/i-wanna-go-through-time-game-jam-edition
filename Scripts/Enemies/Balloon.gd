tool
extends EnemyInterface

export(float, -300.0, 300.0, 5.0) var x_mov := 0.0
export(float, -300.0, 300.0, 5.0) var y_mov := 2.0
export(float, 0.0, 2.0, 0.1) var move_multi := 1.0
export(float, 0.0, 2.0) var jump_multi := 1.0

var _player_above := false
var _random_sin_offset := rand_range(0.0, 1000)
onready var anim := $Sprite

func _physics_process(delta: float):
	position.x = cos(deg2rad((Time.get_ticks_msec()+_random_sin_offset) / 10.0)) * (x_mov*move_multi)
	position.y = sin(deg2rad((Time.get_ticks_msec()+_random_sin_offset) / 10.0)) * (y_mov*move_multi)

func _jumped_on(delta: float) -> bool:
	return _player_above

func _when_idle(delta: float, binds: Array):
	var player: Player = get_tree().current_scene.find_node("PlayerController").get_player()
	if player != null:
		$Sprite.flip_h = global_position.x > player.global_position.x

func _when_die(delta: float, binds: Array):
	pass

func _die():
	$Hitbox.set_deferred("monitoring", false)
	$Hurtbox.set_deferred("monitoring", false)
	$Jumpbox.set_deferred("monitoring", false)
	anim.play("pop")

func _respawn():
	$Hitbox.set_deferred("monitoring", true)
	$Hurtbox.set_deferred("monitoring", true)
	$Jumpbox.set_deferred("monitoring", true)
	anim.play("default")
	._respawn()

func _on_Hurtbox_body_entered(body: Player):
	if body == null or _player_above:
		return
	pl = body
	_player_enter()

func _on_Jumpbox_body_entered(body: Player):
	if body == null:
		return
	if body.speed.y <= 0:
		return
	_player_above = true
	body.speed.y = body.jump_height * jump_multi


func _on_Jumpbox_body_exited(body):
	if body == null:
		return
	_player_above = false


func _on_Sprite_animation_finished():
	if anim.animation == "bounced":
		anim.play("pop")
	elif anim.animation == "pop":
		anim.stop()
		._die()
		$Pop.pitch_scale = rand_range(0.8, 1.2)
		$Pop.play()
#		queue_free()
