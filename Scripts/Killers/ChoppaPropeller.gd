extends EnemyBulletBase

const split := preload("res://Scenes/Hazards/GenericEnemyBullet.tscn")

var speed := Vector2.ZERO
var gravity = -4

func _physics_process(delta: float):
	move_and_slide(speed, Vector2.UP)
	speed.y += gravity
	var col_amt := get_slide_count()
	for i in range(col_amt):
		var col = get_slide_collision(i)
		if (col != null and not col.collider is KinematicBody2D):
			var par = get_parent()
			var bul = split.instance()
			bul.global_position = global_position
			bul.get_node("Hitbox").speed = Vector2(0, 100)
			par.add_child(bul)
			bul.get_node("Hitbox").connect("destroyed", par, "queue_free")
			queue_free()
