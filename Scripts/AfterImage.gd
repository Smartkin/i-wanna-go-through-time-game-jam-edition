extends Sprite

var blend_mode := CanvasItemMaterial.BLEND_MODE_MIX
var dur := 0.5
var target_scale := Vector2.ONE

func _enter_tree():
	material.blend_mode = blend_mode
	var alpha = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	alpha.tween_property(self, "self_modulate:a", 0.0, dur)
	alpha.parallel().tween_property(self, "scale", target_scale, dur)
	alpha.tween_callback(self, "queue_free")
