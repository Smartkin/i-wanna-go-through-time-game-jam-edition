extends EnemyInterface

export(float, 50.0, 500.0) var slide_speed = 100.0

var target_player: Player = null
var has_target := false
var slide_dir: Vector2 = Vector2.UP
var wall_met := false
var speed := 0.0

onready var vis_ray := $PlayerVisibility
onready var vis_ray2 := $PlayerVisibility2
onready var vis_ray3 := $PlayerVisibility3
onready var vis_ray4 := $PlayerVisibility4
onready var anim := $Sprite

func _when_idle(delta: float, binds: Array):
	search_player()

func _when_slide(delta: float, binds: Array):
	move_and_slide(slide_dir * speed, slide_dir.rotated(deg2rad(180)))
	wall_met = is_on_floor()
	if (wall_met):
		print("Met wall")

func player_in_sight(delta: float) -> bool:
	return has_target

func met_wall(delta: float) -> bool:
	return wall_met

func _on_Hitbox_body_entered(bul: Bullet):
	if bul == null:
		return
	bul.destroy()

func calc_player_pos_clamped(ray: RayCast2D) -> Vector2:
	var dir: Vector2 = ray.global_position.direction_to(target_player.global_position)
	var abs_dir := Vector2(abs(dir.x), abs(dir.y))
	var angle = rad2deg(abs_dir.angle())
	if (angle > 30 and angle < 60):
		return Vector2.INF
	dir = Vector2(round(dir.x), round(dir.y))
	var dist: float = ray.global_position.distance_to(target_player.global_position)
	return dist * dir

func search_player():
	if target_player == null:
		return
#	var dir: Vector2 = vis_ray.global_position.direction_to(target_player.global_position)
#	var abs_dir := Vector2(abs(dir.x), abs(dir.y))
#	var angle = rad2deg(abs_dir.angle())
#	dir = Vector2(round(dir.x), round(dir.y))
#	var dist: float = vis_ray.global_position.distance_to(target_player.global_position)
	var cast1 := calc_player_pos_clamped(vis_ray)
	var cast2 := calc_player_pos_clamped(vis_ray2)
	var cast3 := calc_player_pos_clamped(vis_ray3)
	var cast4 := calc_player_pos_clamped(vis_ray4)
	if (cast1 == Vector2.INF or cast2 == Vector2.INF or cast3 == Vector2.INF or cast4 == Vector2.INF):
		return
	vis_ray.cast_to = cast1
	vis_ray2.cast_to = cast2
	vis_ray3.cast_to = cast3
	vis_ray4.cast_to = cast4
	if vis_ray.get_collider() as Player != null or vis_ray2.get_collider() as Player != null or \
		vis_ray3.get_collider() as Player != null or vis_ray4.get_collider() as Player != null:
		if not has_target:
			has_target = true
			slide_dir = vis_ray.cast_to.normalized()
			speed = 0.0
			anim.play("going")
			var slide_tween := create_tween()
			slide_tween.tween_property(self, "speed", slide_speed, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
#			emit_signal("player_spotted")

func _on_Proximity_body_entered(body: Player):
	target_player = body


func _on_Proximity_body_exited(body):
	target_player = null
	has_target = false
