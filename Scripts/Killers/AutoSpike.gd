tool
extends KinematicBody2D

onready var n_SpikeOrientation : AnimationPlayer = $SpikeOrientation
onready var n_BlockChecker : Area2D = $BlockChecker

enum SPIKE_DIRECTION {
	AUTO = -1,
	RIGHT,
	DOWN,
	LEFT,
	UP,
}

export(SPIKE_DIRECTION) var spike_dir := SPIKE_DIRECTION.AUTO
var check_dir := 0


func _ready() -> void:
	add_to_group("Killers")


func _physics_process(delta: float) -> void:
	if spike_dir != SPIKE_DIRECTION.AUTO:
		set_spike_dir(spike_dir)
	elif check_dir < SPIKE_DIRECTION.LEFT:
		_check_for_solids()


func set_spike_dir(value: int) -> void:
	spike_dir = value
	match(value):
		SPIKE_DIRECTION.RIGHT:
			n_SpikeOrientation.play("right")
		SPIKE_DIRECTION.DOWN:
			n_SpikeOrientation.play("down")
		SPIKE_DIRECTION.LEFT:
			n_SpikeOrientation.play("left")
		SPIKE_DIRECTION.UP:
			n_SpikeOrientation.play("RESET")


func _check_for_solids() -> void:
	check_dir += 1
	var dir = deg2rad(90 * float(check_dir))
	n_BlockChecker.position = Vector2(cos(dir), sin(dir))*2.0


func _on_BlockChecker_body_entered(body: Node) -> void:
	set_spike_dir(check_dir)
