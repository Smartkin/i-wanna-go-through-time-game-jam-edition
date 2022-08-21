extends EnemyInterface

const PROJ := preload("res://Scenes/Hazards/PassEnemyBullet.tscn")
const AFTER_IMAGE := preload("res://Scenes/AfterImage.tscn")

var do_trail := false

onready var anim := $AnimatedSprite

func __ready():
	$Animations.play("Lunge")

func _disable():
	pass

func _enable():
	pass

func spawn_circle():
	for i in range(0, 361, 20):
		var proj := PROJ.instance()
		proj.get_node("Hitbox").speed = Vector2(200, 0).rotated(deg2rad(i))
		get_tree().current_scene.add_child(proj)
		proj.global_position = $AnimatedSprite/Punch1.global_position

func hit_ceiling():
	pass

func create_after_image():
	if (do_trail):
		return
	
	do_trail = true
	while do_trail:
		var trail: Sprite = AFTER_IMAGE.instance()
		trail.scale = anim.scale
		trail.texture = anim.frames.get_frame(anim.animation, anim.frame)
		trail.global_position = anim.global_position
		get_tree().current_scene.add_child(trail)
		yield(get_tree().create_timer(1.0), "timeout")

func stop_after_image():
	do_trail = false
