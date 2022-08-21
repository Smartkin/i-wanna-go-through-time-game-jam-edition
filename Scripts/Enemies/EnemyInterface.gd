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
#	var notifier := VisibilityNotifier2D.new()
#	notifier.name = "ViewportChecker"
#	add_child(notifier)
#	notifier.connect("viewport_exited", self, "_die")
#	notifier.connect("viewport_entered", self, "_respawn")
#	var sprite: Node2D = $Sprite
#	if sprite is Sprite:
#		notifier.rect = sprite.get_rect()
#	elif sprite is AnimatedSprite:
#		notifier.rect = Rect2(position, sprite.frames.get_frame(sprite.animation, 0).get_size())
	add_to_group("enemies")
	__ready()


func __ready():
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
	_disable()
	visible = false
#	queue_free()

func _respawn():
	if dead:
		_enable()
		dead = false
		visible = true
		$StateMachine.reset()
		print("respawned")

func _disable():
	dead = true
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	$Hitbox.set_deferred("monitoring", false)
	$Hurtbox.set_deferred("monitoring", false)
	visible = false
	for c in get_children():
		c.set_process(false)
		c.set_process_input(false)
		c.set_physics_process(false)

func _enable():
	set_process(true)
	set_process_input(true)
	set_physics_process(true)
	$Hitbox.set_deferred("monitoring", true)
	$Hurtbox.set_deferred("monitoring", true)
	for c in get_children():
		c.set_process(true)
		c.set_process_input(true)
		c.set_physics_process(true)

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
