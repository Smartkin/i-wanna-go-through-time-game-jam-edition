extends Node2D

# Constants
# Bullet object information
const Bullet := preload("res://Scenes/Player/Bullet.tscn")

# Public
var player_dead := false

var _camera_follow_player_state := {}
var _cam_lock := false
var _cam_manip := false
var limits_to_set := {}

func _ready():
	_camera_follow_player_state = {
		limit_top = $Camera.limit_top,
		limit_bottom = $Camera.limit_bottom,
		limit_left = $Camera.limit_left,
		limit_right = $Camera.limit_right,
	}

func _physics_process(delta: float) -> void:
	if (not player_dead and not _cam_manip):
		$Camera.position = $Player.position


func _input(event: InputEvent) -> void:
	var zoomSpeed = Vector2(0.05, 0.05)
	var maxZoomOut = Vector2(1, 1)
	var maxZoomIn = Vector2(0.05, 0.05)
	if (WorldController.DEBUG_MODE):
		if (Input.is_mouse_button_pressed(BUTTON_WHEEL_UP)):
			if ($Camera.zoom.x - zoomSpeed.x <= maxZoomIn.x):
				$Camera.zoom = maxZoomIn
			else:
				$Camera.zoom -= zoomSpeed
			print($Camera.zoom.length())
		if (Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN)):
			$Camera.zoom += zoomSpeed
			print($Camera.zoom.length())
			if ($Camera.zoom.x >= maxZoomOut.x):
				$Camera.zoom = maxZoomOut
		_cam_manip = false
		if (Input.is_key_pressed(ord("F"))):
			$Camera.global_position = get_global_mouse_position()
			_cam_manip = true

# Callback from WorldController when scene is changed and finishes being built
func _on_scene_built() -> void:
	if (WorldController.loading_save):
		position.x = WorldController.cur_save_data.playerPosX
		position.y = WorldController.cur_save_data.playerPosY
		$Player.health = WorldController.cur_save_data.health
	$Camera.current = true
	$Camera.reset_smoothing()

# Callback when player shoots
func _on_Player_shoot(direction: int) -> void:
	$Sounds/Shoot.play()
	var b := Bullet.instance() # Create bullet object
	var xPosOffset := -9 if direction == -1 else 9
	var yPosOffset := -3 if WorldController.reverse_grav else 3 # Offset it against player's vertical position
	add_child(b)
	b.speed = Vector2(1500 * direction, 0)
	b.position = Vector2($Player.position.x + xPosOffset, $Player.position.y + yPosOffset)

# Callback when player needs to play a sound
func _on_Player_sound(soundName: String) -> void:
	var sound = get_node("Sounds/" + soundName)
	sound.play()

# Callback when blood timer times out
func _on_BloodTimer_timeout():
	$Blood.emitting = false

# Callback when player dies
func _on_Player_dead(playerPos: Vector2) -> void:
	global_position = playerPos
	$Camera.position = Vector2.ZERO
	$Blood.emitting = true
	$Blood.global_position = playerPos
	$BloodTimer.start()
	$Sounds/Death.play()
	player_dead = true
	WorldController.cur_save_data.deaths += 1
	WorldController.save_to_file() # Save only deaths/time
	$CheckpointTeleport.start()


func _on_Player_dashed():
	$CameraTween.interpolate_property($Camera, "offset", Vector2(-20, -20), \
		Vector2(0, 0), 0.1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$CameraTween.start()

func zoom_camera(amount: float, smooth: bool = true, time: float = 1.0):
	if (not smooth):
		$Camera.zoom = Vector2(amount, amount)
		return
	var cur_zoom = $Camera.zoom
	$CameraTween.interpolate_property($Camera, "zoom", cur_zoom, Vector2(amount, amount), time, \
		Tween.TRANS_SINE, Tween.EASE_OUT)
	$CameraTween.start()

func reset_camera():
	$Camera.limit_top = _camera_follow_player_state.limit_top
	$Camera.limit_bottom = _camera_follow_player_state.limit_bottom
	$Camera.limit_right = _camera_follow_player_state.limit_right
	$Camera.limit_left = _camera_follow_player_state.limit_left
	_cam_lock = false

func lock_camera(pos: Vector2, size: Vector2):
	$Camera.limit_smoothed = true
	$Camera.reset_smoothing()
	var view_size = get_viewport_rect().size
	if size.y < view_size.y:
		size.y = view_size.y
		
	if size.x < view_size.x:
		size.x = view_size.x
	
	var cam = $Camera
	cam.limit_top = pos.y
	cam.limit_left = pos.x
	
	cam.limit_bottom = cam.limit_top + size.y
	cam.limit_right = cam.limit_left + size.x
	
	_cam_lock = true

func _on_Player_damaged():
	$Sounds/Death.play()

func player_alive():
	WorldController.load_game(false, 0.4)

func _on_CheckpointTeleport_timeout():
	_cam_lock = true
#	var player_save_pos := Vector2(WorldController.cur_save_data.playerPosX, WorldController.cur_save_data.playerPosY)
##	var come_back_tween := create_tween()
#	var dur := 0.4
#	var trans := WorldController.do_transition(dur)
#	trans.connect("transition_finished", self, "player_alive")
#	come_back_tween.tween_property($Camera, "global_position", \
#		player_save_pos, \
#		dur).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
#	come_back_tween.parallel().tween_property($Player, "global_position", \
#		player_save_pos, \
#		dur).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
#	come_back_tween.parallel().tween_property($Player, "global_position", \
#		player_save_pos, \
#		dur).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
#	come_back_tween.parallel().tween_property($Blood, "global_position", \
#		player_save_pos, \
#		dur).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
#	come_back_tween.tween_callback($Player, "return_to_live")
#	come_back_tween.tween_callback(self, "player_alive")
	$Player.speed = Vector2.ZERO
	$Player.health = WorldController.cur_save_data.health
	player_alive()
