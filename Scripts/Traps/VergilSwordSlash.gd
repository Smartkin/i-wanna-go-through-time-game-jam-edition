extends Area2D


func _ready() -> void:
	modulate.a = 0.0
	scale.y = 0.0
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0.5, 1.0)
	tween.parallel().tween_property(self, "scale:y", 0.3, 1.0)


func slash() -> void:
	$CollisionShape2D.disabled = false
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 1.0, 0.1)
	tween.parallel().tween_property(self, "scale:y", 1.0, 0.1)


func withdraw() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(self, "scale:y", 0.0, 0.3)
	yield(tween, "finished")
	queue_free()