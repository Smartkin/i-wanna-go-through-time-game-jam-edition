class_name Gorfo
extends EnemyInterface

signal player_spotted

const Shot := preload("res://Scenes/Hazards/GorfoShot.tscn")

export var speed := 100

var has_target := false
var target_player: Player = null setget set_target_player
var reverse_speed := false
var walk_speed := 0

var anim: AnimatedSprite = null
var vis_ray: RayCast2D = null
var timer: Timer = null
var walk_timer: Timer = null

func __ready():
	.__ready()
	anim = $Sprite
	vis_ray = $PlayerVisibility
	timer = $Shoot
	walk_timer = $Walking

func _when_walk(delta: float, binds: Array):
	search_player()

func _when_spit(delta: float, binds: Array):
	vis_ray.cast_to = target_player.global_position - vis_ray.global_position
	if $PlayerVisibility.get_collider() as Player == null:
		timer.stop()
		has_target = false

func set_target_player(player: Player):
	target_player = player

func search_player():
	if target_player == null:
		return
	vis_ray.cast_to = target_player.global_position - vis_ray.global_position
	if $PlayerVisibility.get_collider() as Player != null:
		if not has_target:
			has_target = true
			if (timer != null):
				timer.start()
			if (walk_timer != null):
				walk_timer.stop()
			emit_signal("player_spotted")

func walk(sp: int):
	sp = -sp if reverse_speed else sp
	walk_speed = sp
	# Wall check
	move_and_slide(Vector2(sp, 0), Vector2.UP)
	$Sprite.flip_h = reverse_speed
	$Proximity.scale.x = -1 if reverse_speed else 1
	if _on_edge() or is_on_wall():
		reverse_speed = !reverse_speed

func _enable():
	._enable()
	$Proximity.set_deferred("monitoring", true)

func _disable():
	._disable()
	$Proximity.set_deferred("monitoring", false)

func _on_edge() -> bool:
	if walk_speed > 0:
		return not $RightEdge.is_colliding()
	else:
		return not $LeftEdge.is_colliding()

func _no_player_in_sight(delta: float) -> bool:
	return not has_target


func _on_Proximity_body_entered(body: Player):
	target_player = body


func _on_Proximity_body_exited(body):
	target_player = null
	has_target = false
	if (timer != null):
		timer.stop()


func _on_Shoot_timeout():
	var bul := Shot.instance()
	get_tree().current_scene.add_child(bul)
	bul.global_position = $ShootPos.global_position
	bul.get_node("Hitbox").speed = Vector2(target_player.global_position.x - global_position.x, -100)
	anim.play("spit")


func _on_Walking_timeout():
	anim.play("walk")
	$WalkTween.interpolate_method(self, "walk", walk_speed, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$WalkTween.start()


func _on_Sprite_animation_finished():
	anim.stop()
