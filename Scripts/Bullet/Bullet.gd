class_name Bullet
extends RigidBody2D

var speed := Vector2.ZERO
var stats := {
	damage = WorldController.cur_save_data.gun_power
}


func _ready() -> void:
	$Timer.start()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity = speed
	if (state.get_contact_count() != 0):
		if ($EnemyCheck.is_colliding()):
			$EnemyCheck.get_collider().get_parent().damaged(self)
		if ($BreakableBlockCheck.is_colliding()):
			$BreakableBlockCheck.get_collider().break_block()
		destroy()

func destroy():
	queue_free()

func _on_Timer_timeout() -> void:
	destroy()
