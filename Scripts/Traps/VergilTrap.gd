extends Position2D

export var fx_fade_dur := 2.0
export var fx_vignette_alpha := 0.7
# Color tint
export var fx_brightness := -0.125
export var fx_contrast := 1.3
export var fx_saturation := 0.4
export var fx_red := 0.0
export var fx_green := 0.7
export var fx_blue := 0.7
# Glitch effect
export var fx_shake_pow := 0.05
export var fx_color_rate := 0.01
# Anti fisheye
export var fx_fisheye := -0.15

# These are passed to the shaders
var brightness := 0.0
var contrast := 1.0
var saturation := 1.0
var red := 1.0
var green := 1.0
var blue := 1.0
var shake_pow := 0.0
var color_rate := 0.0
var fisheye := 0.0

var active := false
var is_slashing := false
var has_hit_player := false
var blades_counts := [3, 3, 3, 12]
var blade_spawn_delay := 0.3
var blade_slash_delays := [0.2, 0.2, 0.3, 0.5]
var target_player: Player = null
var target_slowdown := 500.0
var game_spd := 1.0

onready var n_SwordSlashes := $SwordSlashes
onready var n_Vignette := $ScreenFX/Vignette
onready var n_ScreenTint := $ScreenFX/ScreenTint
onready var n_Glitch := $ScreenFX/Glitch
onready var n_AntiFisheye := $ScreenFX/AntiFisheye
onready var n_YouShallDie := $YouShallDieSfx
onready var n_SwordSlashesSfx := $SwordSlashesSfx
onready var n_KidSlashedSfx := $KidSlashedSfx
onready var n_VideoPlayer := $VideoLayer/VideoPlayer

var s_SwordSlash := preload("res://Scenes/Traps/VergilSwordSlash.tscn")


func _process(delta: float) -> void:
	if active:
		update_shader_uniforms()
		if !has_hit_player or !is_slashing:
			Engine.time_scale = game_spd


func update_shader_uniforms() -> void:
	# Tint shader
	n_ScreenTint.get_material().set_shader_param("brightness", brightness)
	n_ScreenTint.get_material().set_shader_param("contrast", contrast)
	n_ScreenTint.get_material().set_shader_param("saturation", saturation)
	n_ScreenTint.get_material().set_shader_param("redVal", red)
	n_ScreenTint.get_material().set_shader_param("greenVal", green)
	n_ScreenTint.get_material().set_shader_param("blueVal", blue)
	# Glitch shader
	n_Glitch.get_material().set_shader_param("shake_power", shake_pow)
	n_Glitch.get_material().set_shader_param("shake_color_rate", color_rate)
	# Fisheye shader
	n_AntiFisheye.get_material().set_shader_param("ScalarUniform", fisheye)


func _on_Trigger_body_entered(body: Player) -> void:
	if active:
		return
	
	active = true
	target_player = body
	n_SwordSlashes.visible = true
	enable_fx()
	spawn_blades()
	WorldController.fade_music()  #TODO: make it only fade the music!
	n_YouShallDie.play()


func enable_fx() -> void:
	$ScreenFX.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(n_Vignette, "self_modulate:a", fx_vignette_alpha, fx_fade_dur)
	tween.parallel().tween_property(self, "brightness", fx_brightness, fx_fade_dur)
	tween.parallel().tween_property(self, "contrast", fx_contrast, fx_fade_dur)
	tween.parallel().tween_property(self, "saturation", fx_saturation, fx_fade_dur)
	tween.parallel().tween_property(self, "red", fx_red, fx_fade_dur)
	tween.parallel().tween_property(self, "green", fx_green, fx_fade_dur)
	tween.parallel().tween_property(self, "blue", fx_blue, fx_fade_dur)
	tween.parallel().tween_property(self, "fisheye", fx_fisheye, fx_fade_dur)


func disable_fx() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "game_spd", 1.0, (fx_fade_dur/2.0) / target_slowdown)
	tween.parallel().tween_property(n_Vignette, "self_modulate:a", 0.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "brightness", 0.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "contrast", 1.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "saturation", 1.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "red", 1.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "green", 1.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "blue", 1.0, fx_fade_dur/2.0)
	tween.parallel().tween_property(self, "fisheye", 0.0, fx_fade_dur/2.0)
	WorldController.fade_music(WorldController.FADE_MODE.IN, fx_fade_dur/2.0, 1.0)
	(yield(tween, "finished"))
	# Trap passed, delete to conserve memory
	queue_free()


func spawn_blades() -> void:
	var rand_offset
	if target_player != null:
		var cam: Camera2D = get_tree().current_scene.find_node("PlayerController").get_node("Camera")
		var view_center := cam.get_camera_screen_center()
		for i in blades_counts.size():
			rand_offset = 30.0
			for blade in blades_counts[i]:
				var slash = s_SwordSlash.instance()
				var rand_vec = Vector2(rand_range(-rand_offset, rand_offset), rand_range(-rand_offset, rand_offset))
				slash.global_position = view_center + rand_vec
				n_SwordSlashes.call_deferred("add_child", slash)
				slash.connect("body_entered", self, "_blade_has_touched_player")
				rand_offset += 200.0
			# Wait until we can spawn the next wave of blades
			(yield(get_tree().create_timer(blade_spawn_delay), "timeout"))
	slow_down_time()


func slow_down_time() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "game_spd", 1.0/target_slowdown, 0.5)


func _blade_has_touched_player(body: Node) -> void:
	if has_hit_player:
		return
	
	has_hit_player = true
	Engine.time_scale = 1.0
	$ScreenFX.visible = false
	$VideoLayer.visible = true
	n_VideoPlayer.play()
	n_SwordSlashesSfx.stop()
	n_KidSlashedSfx.play()
	if target_player != null:
		target_player.run_speed = 0
		target_player.gravity = 0


func _on_YouShallDieSfx_finished() -> void:
	var blade_id := 0
	
	is_slashing = true
	n_SwordSlashesSfx.play()
	
	for i in blades_counts.size():
		if has_hit_player:
			break
		
		shake_pow = fx_shake_pow
		color_rate = fx_color_rate
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "shake_pow", 0.0, 0.1 / target_slowdown)
		tween.parallel().tween_property(self, "color_rate", 0.0, 0.1 / target_slowdown)
			
		for blade in blades_counts[i]:
			print(game_spd)
			n_SwordSlashes.get_child(blade_id).speed_mult = game_spd
			n_SwordSlashes.get_child(blade_id).slash()
			blade_id += 1
		# Wait until we can slash more blades
		(yield(get_tree().create_timer(blade_slash_delays[i] / target_slowdown), "timeout"))
	blade_slashes_finished()


func blade_slashes_finished() -> void:
	if has_hit_player:
		return
	
	for blade in n_SwordSlashes.get_children():
		blade.withdraw()
	disable_fx()


func _on_VideoPlayer_finished():
	WorldController.load_game()
