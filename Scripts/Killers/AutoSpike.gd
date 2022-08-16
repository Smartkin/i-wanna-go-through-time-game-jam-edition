tool
extends KinematicBody2D

onready var n_SpikeOrientation := $SpikeOrientation
onready var n_BlockChecker := $BlockChecker

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
	if spike_dir != SPIKE_DIRECTION.AUTO:
		set_spike_dir(spike_dir)
	else:
		_check_for_solids()

func _process(delta):
	if Engine.editor_hint:
		if spike_dir != SPIKE_DIRECTION.AUTO:
			set_spike_dir(spike_dir)
		else:
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
	for i in range(4):
		if spike_dir != SPIKE_DIRECTION.AUTO:
			break
		check_dir = i
		var dir = deg2rad(90 * i)
		n_BlockChecker.position = Vector2(cos(dir), sin(dir))*3.0
		print(Vector2(cos(dir), sin(dir)))


func _on_BlockChecker_body_entered(body: Node) -> void:
	set_spike_dir(check_dir)
