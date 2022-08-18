extends EnemyInterface

export var speed := 200
export var slide_speed := 500
var _player_above := false
var can_slide := true
var track_player: Player = null
var _lost_target := false
var reverse_speed := false

onready var init_speed := speed
onready var anim := $Sprite

func _when_walk(delta: float, binds: Array):
	# Wall check
	move_and_slide(Vector2(speed, 0), Vector2.UP)
	$Sprite.flip_h = speed < 0
	if _on_edge() or is_on_wall():
		speed = -speed

func _when_slide(delta: float, binds: Array):
	if (track_player == null):
		return
	if (can_slide):
		var sp = -slide_speed if global_position.x > track_player.global_position.x else slide_speed
		$SlideTween.interpolate_method(self, "slide", sp, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$SlideTween.start()
		can_slide = false
	$Sprite.flip_h = speed < 0

func slide(sp: int):
	sp = -sp if reverse_speed else sp
	speed = sp
	move_and_collide(Vector2(sp, 0) * get_physics_process_delta_time())
	# Wall check
	move_and_slide(Vector2.ZERO, Vector2.UP)
	if _on_edge() or is_on_wall():
		reverse_speed = !reverse_speed

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
	return (not $LeftEdge.is_colliding() and not $RightEdge.is_colliding())

func _no_player_in_sight(delta: float) -> bool:
	return _lost_target

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

func _on_SlideWait_timeout():
	can_slide = true
	if (track_player == null):
		_lost_target = true


func _on_SlideTween_tween_completed(object, key):
	$SlideWait.start()
	reverse_speed = false


func _on_ProximityCheck_body_entered(body):
	_lost_target = false
