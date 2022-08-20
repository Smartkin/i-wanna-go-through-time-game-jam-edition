extends Area2D

var speed_mult := 1.0


func _ready() -> void:
	modulate.a = 0.0
	rotation_degrees = rand_range(0.0, 360.0)
	scale.x = 1000.0
	scale.y = 0.0
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0.5, 0.5)
	tween.parallel().tween_property(self, "scale:y", 0.15, 0.5)


func slash() -> void:
	modulate.a = 1.0
	scale.y = 1.5
	$CollisionShape2D.disabled = false
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale:y", 1.0, 0.1 * speed_mult)


func withdraw() -> void:
	$CollisionShape2D.disabled = true
	var tween := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(self, "scale:y", 0.0, 0.3)
	yield(tween, "finished")
	queue_free()
