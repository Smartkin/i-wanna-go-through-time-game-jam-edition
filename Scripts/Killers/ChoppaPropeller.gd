extends EnemyBulletBase

const split := preload("res://Scenes/Hazards/GenericEnemyBullet.tscn")

var speed := Vector2.ZERO
var gravity = -4

func _physics_process(delta: float):
	position += speed * delta
	var col = move_and_collide(Vector2.ZERO, true, true, true)
	speed.y += gravity
	if (col != null and not col.collider is KinematicBody2D):
		var par = get_parent()
		var bul = split.instance()
		bul.speed = Vector2(0, 100)
		par.add_child(bul)
		bul.connect("destroyed", par, "queue_free")
		queue_free()
