class_name EnemyInterface
extends KinematicBody2D

signal died

var pl: Player = null
var path_to_player := PoolVector2Array() setget set_path_to_player  # Only supplied if part of "chasing_enemies" group
var stats := {
	hp = 1,
	power = 1
}
var dead := false

func _ready():
	$Hurtbox.connect("body_entered", self, "_on_Hurtbox_body_entered")
	$Hurtbox.connect("body_exited", self, "_on_Hurtbox_body_exited")
	$Hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	set_meta("enemy", true)

# Virtual function on player entering the area, by default just hits the player
func _player_enter():
	pl.damage(stats.power)

# Virtual function on running out of HP/dying
func _die():
	dead = true
	emit_signal("died")
	queue_free()

func _on_Hurtbox_body_entered(body: Player):
	if body == null:
		return
	pl = body
	_player_enter()


func _on_Hurtbox_body_exited(body: Player):
	if body == null:
		return
	pl = null

func damaged(bul: Bullet):
	_on_Hitbox_body_entered(bul)

func _on_Hitbox_body_entered(bul: Bullet):
	if bul == null:
		return
	stats.hp -= bul.stats.damage
	bul.destroy()
	if stats.hp <= 0:
		_die()


func set_path_to_player(value: PoolVector2Array) -> void:
	path_to_player = value
