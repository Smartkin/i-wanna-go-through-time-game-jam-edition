extends Sprite

func _enter_tree():
	var alpha = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	alpha.tween_property(self, "modulate:a", 0, 0.2)
	alpha.tween_callback(self, "queue_free")
