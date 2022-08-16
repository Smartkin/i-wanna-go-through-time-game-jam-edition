tool
extends EnemyInterface

export(float, 0.0, 1000.0, 0.5) var x_mov := 0.0
export(float, 0.0, 1000.0, 0.5) var y_mov := 2.0
var _player_above := false

func _physics_process(delta: float):
	position.x = cos(deg2rad(Time.get_ticks_msec() / 10.0)) * x_mov
	position.y = sin(deg2rad(Time.get_ticks_msec() / 10.0)) * y_mov


func _on_Jumpbox_body_entered(body:Node):
	if body == null:
		return
	if body.speed.y <= 0:
		return
	_player_above = true
	body.speed.y = body.jump_height * 1.5
