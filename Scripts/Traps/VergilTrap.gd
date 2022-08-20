extends Node

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
export var fx_shake_pow := 0.01
export var fx_color_rate := 0.005
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
var blades_counts := [3, 3, 3, 8]
var blade_spawn_delay := 0.3
var blade_slash_delays := [0.2, 0.2, 0.25]
var target_player: Player = null
var target_slowdown = 100
var game_spd = 1

onready var n_Vignette := $ScreenFX/Vignette
onready var n_ScreenTint := $ScreenFX/ScreenTint
onready var n_Glitch := $ScreenFX/Glitch
onready var n_AntiFisheye := $ScreenFX/AntiFisheye
onready var n_YouShallDie := $YouShallDie
onready var n_SwordSlashes := $SwordSlashes

var s_SwordSlash := preload("res://Scenes/Traps/VergilSwordSlash.tscn")


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if active:
		update_shader_uniforms()
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
	active = true
	target_player = body
	enable_fx()
	spawn_blades()
	WorldController.fade_music()
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


func spawn_blades() -> void:
	var rand_offset
	if target_player != null:
		for i in blades_counts.size():
			rand_offset = 20.0
			for blade in blades_counts[i]:
				var slash = s_SwordSlash.instance()
				var rand_vec = Vector2(rand_range(-rand_offset, rand_offset), rand_range(-rand_offset, rand_offset))
				slash.global_position = target_player.global_position + rand_vec
				n_SwordSlashes.add_child(slash)
				rand_offset += 100.0
			# Wait until we can spawn the next wave of blades
			yield(get_tree().create_timer(blade_spawn_delay), "timeout")


func slow_down_time() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "game_spd", 0.0/target_slowdown, 2.0)


func _on_YouShallDie_finished() -> void:
	pass
