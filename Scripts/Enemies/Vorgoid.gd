#tool
extends Gorfo

const Bul := preload("res://Scenes/Hazards/PassEnemyBullet.tscn")

export(float, 0.0, 1000.0, 0.5) var x_mov = 64.0
export(float, 0.0, 1000.0, 0.5) var y_mov = 64.0
export(float, 50.0, 400.0, 0.5) var safe_distance = 100.0
export(float, 50.0, 400.0, 0.5) var follow_speed = 50.0

var _time := 0.0
var _path: Array = []
var at_home := false
onready var home := global_position
onready var nav_agent := $ReturnNavAgent

func __ready():
	$Hurtbox.connect("body_entered", self, "_on_Hurtbox_body_entered")
	$Hurtbox.connect("body_exited", self, "_on_Hurtbox_body_exited")
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	set_meta("enemy", true)
	anim = $Sprite
	timer = $Shoot
	vis_ray = $PlayerVisibility


func _physics_process(delta):
	if Engine.editor_hint:
		_do_movement(delta)

func _do_movement(delta: float):
	_time += delta * 100
	position.x = cos(deg2rad(_time)) * x_mov
	position.y = sin(deg2rad(_time)) * y_mov

func _die():
	dead = true
	emit_signal("died")
	$Hitbox.set_deferred("monitoring", false)
	$Hurtbox.set_deferred("monitoring", false)
	$Proximity.set_deferred("monitoring", false)

func _when_chase(delta: float, binds: Array):
	fly(follow_speed)
	vis_ray.cast_to = target_player.global_position - vis_ray.global_position
	if $PlayerVisibility.get_collider() as Player == null:
		has_target = false
		timer.stop()

func _when_fly(delta: float, binds: Array):
	_do_movement(delta)
	search_player()

func _when_return(delta: float, binds: Array):
	search_player()
	if _path.size() > 0:
		var cur_pos = global_position
		var next = nav_agent.get_next_location()
		var vel = cur_pos.direction_to(next) * follow_speed
		nav_agent.set_velocity(vel)
		var target = nav_agent.get_target_location()
		if (cur_pos.distance_to(target) < 9):
			_path.remove(0)
			if _path.size():
				nav_agent.set_target_location(_path[0])
			else:
				at_home = true

func navigate(path: Array) -> void:
	_path = path
	if path.size():
		nav_agent.set_target_location(path[0])

func fly(sp: float):
	if (target_player != null):
		var dir := global_position.direction_to(.global_position)
		var sp_scale: float = global_position.distance_to(target_player.global_position) / safe_distance - 1
		if (sp_scale < 1 and timer.is_stopped()):
			timer.start()
		if (sp_scale > 1):
			timer.stop()
		move_and_slide(dir * sp * sp_scale, Vector2.UP)
		$Sprite.flip_h = -1 if dir.x < 0 else 1

func fly_home(sp: Vector2):
	$Sprite.flip_h = -1 if sp.x < 0 else 1
	move_and_slide(sp, Vector2.UP)

func get_agent_rid() -> RID:
	return nav_agent.get_navigation_map()

func _came_home(delta: float) -> bool:
	return at_home


func _on_ReturnNavAgent_velocity_computed(safe_velocity: Vector2):
	fly_home(safe_velocity)

func _on_Shoot_timeout():
	var bul := Bul.instance()
	get_tree().current_scene.add_child(bul)
	bul.global_position = global_position
	var dir := global_position.direction_to(target_player.global_position)
	bul.get_node("Hitbox").speed = dir * 100
