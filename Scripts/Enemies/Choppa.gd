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

func _ready():
	._ready()
	timer = $Chasing


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
	$Hitbox.set_deferred("monitoring", false)
	$Hurtbox.set_deferred("monitoring", false)
	$Proximity.set_deferred("monitoring", false)

func _when_chase(delta: float, binds: Array):
	pass

func _when_fly(delta: float, binds: Array):
	_do_movement(delta)
	search_player()

func _when_return(delta: float, binds: Array):
	search_player()
	var cur_pos = global_position
	var next = nav_agent.get_next_location()
	if _path.size() > 0 and not step_flight:
		var vel = cur_pos.direction_to(next) * lunge_speed
		var fly := create_tween()
		fly.tween_method(nav_agent, "set_velocity", vel, Vector2.ZERO, 1.0)
		fly.tween_callback(self, "fly_again")
		step_flight = true
		
	if (cur_pos.distance_to(next) < 1):
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
		var dir := global_position.direction_to(target_player.global_position)
		move_and_slide(dir * sp, Vector2.UP)

func fly_again():
	step_flight = false

func fly_home(sp: Vector2):
	move_and_slide(sp, Vector2.UP)

func get_agent_rid() -> RID:
	return nav_agent.get_navigation_map()

func _came_home(delta: float) -> bool:
	return at_home

func _on_Flying_timeout():
	var fly := create_tween()
	fly.tween_method(self, "fly", lunge_speed, 0.0, 1.0)


func _on_ReturnNavAgent_velocity_computed(safe_velocity: Vector2):
	fly_home(safe_velocity)


func _on_Sprite_animation_finished():
	if (anim.animation == "pop"):
		var par := get_parent()
		var prop := propeller.instance()
		par.add_child(prop)
		prop.global_position = global_position
		queue_free()

