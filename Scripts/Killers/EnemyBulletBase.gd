class_name EnemyBulletBase
extends KinematicBody2D

var damage := 1

func _ready() -> void:
	add_to_group("EnemyBullet")
