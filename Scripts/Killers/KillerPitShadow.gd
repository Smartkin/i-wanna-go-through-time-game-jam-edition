tool
extends Sprite


func _ready():
	$SkullParticles.set_as_toplevel(true)
	set_notify_transform(true)
	$KillerHitbox.add_to_group("Killers")


func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		$SkullParticles.position.x = position.x + 16*scale.x
		$SkullParticles.position.y = position.y + 48
		$SkullParticles.process_material.set("emission_box_extents", Vector3(16.0*scale.x, 1.0, 1.0))
		$SkullParticles.amount = int(scale.x * 1.0)
