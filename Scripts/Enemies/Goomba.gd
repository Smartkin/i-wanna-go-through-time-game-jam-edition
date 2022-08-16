extends EnemyInterface

export var speed := 200
var _player_above := false

func _when_walk(delta: float, binds: Array):
	move_and_collide(Vector2(speed, 0) * delta)
	if _on_edge():
		speed = -speed

func _when_idle(delta: float, binds: Array):
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
	return not $LeftEdge.is_colliding() and not $RightEdge.is_colliding()

func _not_stuck(delta: float) -> bool:
	return not _stuck(delta)

func _on_Jumpbox_body_entered(body: Player):
	if body == null:
		return
	if body.speed.y <= 0:
		return
	_player_above = true
	body.speed.y = body.jump_height * 0.5

func _on_Jumpbox_body_exited(body: Player):
	if body == null:
		return
	_player_above = false
