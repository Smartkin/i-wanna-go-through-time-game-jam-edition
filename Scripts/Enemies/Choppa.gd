tool
extends Gorfo

export(float, 0.0, 1000.0, 0.5) var x_mov = 64.0
export(float, 0.0, 1000.0, 0.5) var y_mov = 64.0
export(float, 50.0, 400.0, 0.5) var lunge_speed = 100.0

const propeller = preload("res://Scenes/Hazards/ChoppaPropeller.tscn")

var _time := 0.0
var _path: Array = []
var step_flight := false
var at_home := false
onready var home := global_position
onready var nav_agent := $ReturnNavAgent

func __ready():
	$Hurtbox.connect("body_entered", self, "_on_Hurtbox_body_entered")
	$Hurtbox.connect("body_exited", self, "_on_Hurtbox_body_exited")
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	set_meta("enemy", true)
	timer = $Chasing
	anim = $Sprite
	vis_ray = $PlayerVisibility
	get_parent().get_node("%NavLine").global_position = Vector2.ZERO


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
	anim.play("pop")

func _when_chase(delta: float, binds: Array):
	vis_ray.cast_to = target_player.global_position - vis_ray.global_position
	if $PlayerVisibility.get_collider() as Player == null:
		timer.stop()
		has_target = false

func _when_fly(delta: float, binds: Array):
	if (dead):
		return
	_do_movement(delta)
	search_player()

func _when_return(delta: float, binds: Array):
	if (dead):
		return
	search_player()
	var cur_pos = global_position
	var next = nav_agent.get_next_location()
#	print(next)
	if _path.size() > 0 and not step_flight:
		var vel = cur_pos.direction_to(next) * lunge_speed
		var fly := create_tween()
		fly.tween_method(nav_agent, "set_velocity", vel, Vector2.ZERO, 1.0)
		fly.tween_callback(self, "fly_again")
		step_flight = true
	var target = nav_agent.get_target_location()
	if (cur_pos.distance_to(target) < 9):
		_path.remove(0)
#		step_flight = false
		get_parent().get_node("%NavLine").points = _path
		if _path.size():
			nav_agent.set_target_location(_path[0])
		else:
			at_home = true

func navigate(path: Array) -> void:
	_path = path
	if path.size():
		nav_agent.set_target_location(path[0])

func fly(sp: float):
	if (target_player != null and not dead):
		var dir := global_position.direction_to(target_player.global_position)
		var res_sp := dir * sp
		move_and_slide(res_sp, Vector2.UP)
		$Sprite.flip_h = res_sp.x < 0

func fly_again():
	step_flight = false

func fly_home(sp: Vector2):
	$Sprite.flip_h = sp.x < 0
	move_and_slide(sp, Vector2.UP)

func get_agent_rid() -> RID:
	return nav_agent.get_navigation_map()

func _came_home(delta: float) -> bool:
	return at_home

func _on_Flying_timeout():
	var fly := create_tween()
	fly.tween_method(self, "fly", lunge_speed, 0.0, 1.0)
	$Move.pitch_scale = rand_range(0.8, 1.2)
	$Move.play()


func _on_ReturnNavAgent_velocity_computed(safe_velocity: Vector2):
	fly_home(safe_velocity)


func _on_Sprite_animation_finished():
	if (anim.animation == "pop"):
		var par := get_parent()
		var prop := propeller.instance()
		par.add_child(prop)
		prop.global_position = global_position
		anim.stop()
		timer.stop()
		_disable()

