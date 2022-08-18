extends EnemyInterface

export var speed := 200

onready var anim := $Sprite

func _when_walk(delta: float, binds: Array):
	# Wall check
	move_and_slide(Vector2(speed, 0), Vector2.UP)
	if _on_edge() or is_on_wall():
		speed = -speed
		$Sprite.flip_h = speed < 0

func _when_idle(delta: float, binds: Array):
	pass

func _on_edge() -> bool:
	if speed > 0:
		return not $RightEdge.is_colliding()
	else:
		return not $LeftEdge.is_colliding()

func _on_Hurtbox_body_entered(body: Player):
	if body == null:
		return
	pl = body
	_player_enter()


func _stuck(delta: float) -> bool:
	return (not $LeftEdge.is_colliding() and not $RightEdge.is_colliding())

func _not_stuck(delta: float) -> bool:
	return not _stuck(delta)

