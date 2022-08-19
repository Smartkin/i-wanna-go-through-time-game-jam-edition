extends EnemyInterface

export var speed := Vector2(30, 0)
export var jump_force := Vector2(80, -300)
export var jump_force_hrand := 1.5
var _player_above := false
var _on_land := false
var gravity := 10
var can_jump := true
var track_player: Player = null

onready var init_spd := speed
onready var anim := $Sprite


func _when_walk(delta: float, binds: Array):
	# Wall check
	move_and_slide(speed, Vector2.UP)
	$Sprite.flip_h = speed.x < 0
	print(is_on_wall())
	if (not is_on_floor()):
		speed.y += gravity
	else:
		_on_land = true
		speed.y = 0
	if _on_edge() or is_on_wall():
		speed.x = -speed.x

func _when_jump(delta: float, binds: Array):
	if (track_player == null):
		return
	move_and_slide(speed, Vector2.UP)
	if (not _on_land or can_jump):
		var hor_jump_force = jump_force.x * rand_range(1.0, jump_force_hrand)
		speed.x = clamp((track_player.global_position.x - 10) - global_position.x, -hor_jump_force, hor_jump_force)
		# Floor check
		can_jump = false
		_on_land = is_on_floor()
		if (_on_land):
			$JumpWait.start()
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
	speed.y = jump_force.y
