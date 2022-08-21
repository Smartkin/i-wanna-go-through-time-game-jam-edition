extends EnemyBulletBase

const split := preload("res://Scenes/Hazards/GenericEnemyBullet.tscn")

var speed := Vector2.ZERO
var gravity = -4

func _ready():
	damage = 2

func _physics_process(delta: float):
	move_and_slide(speed, Vector2.UP)
	speed.y += gravity
	var col_amt := get_slide_count()
	for i in range(col_amt):
		var col = get_slide_collision(i)
		if (col != null and not col.collider is KinematicBody2D):
			var par = get_parent()
			for j in range(180, 361, 10):
				var bul = split.instance()
				bul.global_position = global_position
				bul.get_node("Hitbox").speed = Vector2(-100, 0).rotated(deg2rad(j))
				get_tree().current_scene.add_child(bul)
			par.queue_free()
