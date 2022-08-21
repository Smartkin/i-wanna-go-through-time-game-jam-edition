class_name DamageSource
extends KinematicBody2D

var damage := 1

func _ready():
	add_to_group("DamageSource")
