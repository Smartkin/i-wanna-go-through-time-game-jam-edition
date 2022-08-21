extends Node2D

const PROJ := preload("res://Scenes/Hazards/PassEnemyBullet.tscn")

func spawn_circle():
	for i in range(0, 361, 20):
		var proj := PROJ.instance()
		proj.get_node("Hitbox").speed = Vector2(200, 0).rotated(deg2rad(i))
		get_tree().current_scene.add_child(proj)
		proj.global_position = $AnimatedSprite/Punch1.global_position
