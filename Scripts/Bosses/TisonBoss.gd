extends EnemyInterface

const PROJ := preload("res://Scenes/Hazards/PassEnemyBullet.tscn")
const AFTER_IMAGE := preload("res://Scenes/AfterImage.tscn")

var do_trail := false
var finished_attack := false

onready var anim := $AnimatedSprite
onready var animations := $Animations

func __ready():
	stats.hp = 20
	stats.total_hp = stats.hp
	yield(get_tree().create_timer(2.0), "timeout")
	$AttackStateMachine.start()

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
	for i in range(20, 640, 40):
		var proj := PROJ.instance()
		proj.get_node("Hitbox").speed = Vector2(0, rand_range(50, 200))
		proj.get_node("Hitbox").gravity = 10
		get_tree().current_scene.add_child(proj)
		var offset = Vector2(i, 0)
		var cam := $Camera2D
		proj.global_position = Util.get_view_position(cam) + offset

func punch():
	animations.play("Punch")

func uppercut():
	animations.play("Uppercut")

func lunge():
	animations.play("Lunge")

func attack_finished(delta: float) -> bool:
	return finished_attack

func damaged(bul: Bullet):
	if bul == null:
		return
	stats.hp -= bul.stats.damage
	var hp_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	hp_tween.parallel().tween_property($"%HealthBar", "value", float(stats.hp) / stats.total_hp, 1)
	var mod_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	mod_tween.tween_property(self, "modulate:g", 0.0, 0.2)
	mod_tween.parallel().tween_property(self, "modulate:b", 0.0, 0.2)
	mod_tween.tween_property(self, "modulate:g", 1.0, 0.2)
	mod_tween.parallel().tween_property(self, "modulate:b", 1.0, 0.2)
	bul.destroy()
	if (stats.hp == 0):
		_die()

func _die():
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
		yield(get_tree().create_timer(0.1), "timeout")

func stop_after_image():
	do_trail = false


func _on_Animations_animation_finished(anim_name):
	if (anim_name == "Appear"):
		return
	# Wait a little before starting new attack
	yield(get_tree().create_timer(1.0), "timeout")
	finished_attack = true


func _on_Animations_animation_started(anim_name):
	finished_attack = false
