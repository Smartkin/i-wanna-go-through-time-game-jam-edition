extends EnemyInterface

export var speed := Vector2(30, 0)
export var jump_force := Vector2(80, -300)
export var jump_force_hrand := 100
var _player_above := false
var _on_land := false
var gravity := 10
var can_jump := true
var has_jumped := false
var track_player: Player = null
var last_jump_dir := 1.0

onready var init_spd := speed
onready var anim := $Sprite


func _when_walk(delta: float, binds: Array):
	# Wall check
	if is_on_floor() and has_jumped:
		has_jumped = false
		_land_animation()
	
	move_and_slide(speed, Vector2.UP)
	$Sprite.flip_h = speed.x < 0
	_on_land = false
	if (not is_on_floor()):
		speed.y += gravity
	else:
		speed.y = 0
	if _on_edge() or is_on_wall():
		speed.x = -speed.x

func _when_jump(delta: float, binds: Array):
	if (track_player == null):
		return
	move_and_slide(speed, Vector2.UP)
	if (not _on_land or can_jump):
		if (can_jump):
			var rand_force = jump_force_hrand * randf() * sign(track_player.global_position.x - 10 - global_position.x)
			var hor_jump_force = jump_force.x
			speed.x = clamp((track_player.global_position.x - 10) + rand_force - global_position.x, -hor_jump_force, hor_jump_force)
			last_jump_dir = sign(speed.x)
			$Jump.pitch_scale = rand_range(0.9, 1.3)
			$Jump.play()
			$Sprite.scale.x = 0.5
			$Sprite.scale.y = 1.5
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			tween.tween_property($Sprite, "scale:y", 1.0, 0.2)
			tween.parallel().tween_property($Sprite, "scale:x", 1.0, 0.2)
		# Floor check
		can_jump = false
		_on_land = is_on_floor()
		if (_on_land):
			$JumpWait.start()
			_land_animation()
		speed.y += gravity
		$Sprite.flip_h = speed.x < 0
	if (_on_land):
		speed.x = 0
	if is_on_wall():
		speed.x = -speed.x

func _on_edge() -> bool:
	if speed.x > 0:
		return not $RightEdge.is_colliding()
	else:
		return not $LeftEdge.is_colliding()

func _on_Hurtbox_body_entered(body: Player):
	if body == null or _player_above:
		return
	pl = body
	_player_enter()

func _land_animation() -> void:
	$Land.pitch_scale = rand_range(0.7, 1.3)
	$Land.play()
	$Sprite.scale.x = 2.0
	$Sprite.scale.y = 0.25
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Sprite, "scale:y", 1.0, 0.2)
	tween.parallel().tween_property($Sprite, "scale:x", 1.0, 0.2)

func _enable():
	._enable()
	$ProximityCheck.set_deferred("monitoring", true)

func _disable():
	._disable()
	$ProximityCheck.set_deferred("monitoring", false)

func _stuck(delta: float) -> bool:
	return (not $LeftEdge.is_colliding() and not $RightEdge.is_colliding())

func _landed(delta: float) -> bool:
	return _on_land

func _on_Jumpbox_body_entered(body: Player):
	if body == null:
		return
	if body.speed.y <= 0:
		return
	_player_above = true
	body.speed.y = body.jump_height * 1.5
	body.can_djump = true

func _on_Jumpbox_body_exited(body: Player):
	if body == null:
		return
	_player_above = false

func _on_JumpWait_timeout():
	can_jump = true
	has_jumped = true
	speed.y = jump_force.y
