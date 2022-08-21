extends EnemyInterface

const PROJ := preload("res://Scenes/Hazards/TysonOrb.tscn")
const ROCK := preload("res://Scenes/Hazards/TysonRock.tscn")
const AFTER_IMAGE := preload("res://Scenes/AfterImage.tscn")

var do_trail := false
var finished_attack := false
var pos_index := -1
export var fx_zoom := 0.0

onready var anim := $AnimatedSprite
onready var animations := $Animations
onready var shift_positions := $"%ShiftPositions".get_children()

func __ready():
	stats.hp = 50
	stats.total_hp = stats.hp


func _input(event: InputEvent):
	if (event.is_action_pressed("skip") and animations.current_animation == "Appear"):
		animations.advance(7)

func _disable():
	pass

func _enable():
	pass

func spawn_circle():
	for i in range(0, 361, 40):
		var proj := PROJ.instance()
		proj.get_node("Hitbox").speed = Vector2(200, 0).rotated(deg2rad(i))
		get_tree().current_scene.add_child(proj)
		proj.global_position = $AnimatedSprite/Punch1.global_position

func hit_ceiling():
	var rand_offset = rand_range(-30, 30)
	WorldController.shake_camera(Tween.EASE_OUT, 3.0, 20.0)
	for i in range(70+rand_offset, 570+rand_offset, 60):
		var proj := ROCK.instance()
		proj.get_node("Hitbox").speed = Vector2(0, rand_range(50.0, 150.0))
		proj.get_node("Hitbox").gravity = rand_range(2.0, 10.0)
		get_tree().current_scene.add_child(proj)
		var offset = Vector2(i, 0)
		proj.global_position = Util.get_view_position() + offset

func punch():
	animations.play("Punch")
	(yield(animations, "animation_finished"))
	shift()


func punch_shake() -> void:
	WorldController.shake_camera(Tween.EASE_OUT, 1.0, 5.0)


func uppercut():
	animations.play("Uppercut")
	(yield(animations, "animation_finished"))
	shift()

func lunge():
	if randf() > 0.5:
		animations.play("Lunge")
	else:
		animations.play("LungeBottom")
	(yield(animations, "animation_finished"))
	shift()


func lunge_shake() -> void:
	WorldController.shake_camera(Tween.EASE_OUT, 1.5, 10.0)


func attack_finished(delta: float) -> bool:
	return finished_attack

func _process(delta):
	update_shader_params()

func update_shader_params():
	var mat = $AnimatedSprite.get_material()
	mat.set_shader_param("fxZoomBlur", fx_zoom)

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
		$AttackStateMachine.stop()
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		animations.stop()
		animations.play("Die")
		$Death.play()
		WorldController.fade_music()
		_die()

func _respawn():
	pass

func _die():
	yield(animations, "animation_finished")
	get_tree().current_scene.find_node("MusicPlayer").play()
	emit_signal("died")
	queue_free()

func shift():
	create_after_image()
	if (pos_index + 1 >= shift_positions.size()):
		pos_index = -1
	var pos: Position2D = shift_positions[pos_index + 1]
	pos_index += 1
	var move_tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	move_tween.tween_property(self, "global_position", pos.global_position, 0.5)
	(yield(move_tween, "finished"))
	stop_after_image()

func create_after_image():
	if (do_trail):
		return
	
	do_trail = true
	while do_trail:
		var trail: Sprite = AFTER_IMAGE.instance()
		trail.scale = anim.scale
		trail.target_scale = anim.scale
		trail.texture = anim.frames.get_frame(anim.animation, anim.frame)
		trail.global_position = anim.global_position
		get_tree().current_scene.add_child(trail)
		(yield(get_tree().create_timer(0.05), "timeout"))

func stop_after_image():
	do_trail = false


func _on_Animations_animation_finished(anim_name):
	if (anim_name == "Appear"):
		return
	# Wait a little before starting new attack
	(yield(get_tree().create_timer(1.5), "timeout"))
	finished_attack = true


func _on_Animations_animation_started(anim_name):
	finished_attack = false

func _on_Hitbox_body_entered(bul: Bullet):
	damaged(bul)

func _on_BossTrigger_body_entered(body):
	WorldController.fade_music()
	animations.play("Appear")
	(yield(animations, "animation_finished"))
	WorldController.play_music("tyson")
	$CanvasLayer.visible = true
	# Wait a little before starting to own the player
	(yield(get_tree().create_timer(2.0), "timeout"))
	$AttackStateMachine.start()
