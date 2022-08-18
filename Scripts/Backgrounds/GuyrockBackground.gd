extends ParallaxBackground

export var cloud_spd := -100
export var back_cloud_spd := -20

onready var clouds := $Clouds
onready var back_clouds := $BackClouds


func _ready() -> void:
	visible = true


func _process(delta: float) -> void:
	clouds.motion_offset.x += cloud_spd * delta
	back_clouds.motion_offset.x += back_cloud_spd * delta
