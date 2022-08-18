extends EnemyInterface

export var speed := 70
var _player_above := false


onready var anim := $Sprite

func _when_walk(delta: float, binds: Array):
	# Wall check
	move_and_slide(Vector2(speed, 0), Vector2.UP)
	if _on_edge() or is_on_wall():
		speed = -speed
		$Sprite.flip_h = speed < 0

func _when_idle(delta: float, binds: Array):
	pass

func _when_bounce(delta: float, binds: Array):
	pass

func _on_edge() -> bool:
	if speed > 0:
		return not $RightEdge.is_colliding()
	else:
		return not $LeftEdge.is_colliding()

func _on_Hurtbox_body_entered(body: Player):
	if body == null or _player_above:
		return
	pl = body
	_player_enter()


func _stuck(delta: float) -> bool:
	return (not $LeftEdge.is_colliding() and not $RightEdge.is_colliding()) or _player_above

func _not_stuck(delta: float) -> bool:
	return not _stuck(delta)

func _on_Jumpbox_body_entered(body: Player):
	if body == null:
		return
	if body.speed.y <= 0:
		return
	_player_above = true
	body.speed.y = body.jump_height * 1.5
	body.can_djump = true
	anim.play("bounced")
	anim.frame = 0
	$StunTimer.stop()

func _on_Jumpbox_body_exited(body: Player):
	if body == null:
		return
	_player_above = false

