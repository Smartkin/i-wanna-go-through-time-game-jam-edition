extends KinematicBody2D

onready var n_SpikeOrientation := $SpikeOrientation
onready var n_BlockChecker := $BlockChecker

export(int, -1, 3) var spike_dir := -1
var check_dir := 0


func _ready() -> void:
	add_to_group("Killers")
	if spike_dir != -1:
		set_spike_dir(spike_dir)
	else:
		_check_for_solids()


func set_spike_dir(value: int) -> void:
	spike_dir = value
	match(value):
		0: 
			n_SpikeOrientation.play("right")
		1:
			n_SpikeOrientation.play("down")
		2:
			n_SpikeOrientation.play("left")


func _check_for_solids() -> void:
	for i in range(4):
		if spike_dir != -1:
			break
		check_dir = i
		var dir = deg2rad(90 * i)
		n_BlockChecker.position = Vector2(cos(dir), sin(dir))*3.0
		print(Vector2(cos(dir), sin(dir)))


func _on_BlockChecker_body_entered(body: Node) -> void:
	set_spike_dir(check_dir)
