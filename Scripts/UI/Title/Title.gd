extends Control

onready var file_scene := "res://Rooms/FileSelect.tscn"
onready var options_scene := "res://Rooms/Options.tscn"


func _ready() -> void:
	$Layout/StartGame.grab_focus()


func _on_StartGame_pressed() -> void:
	Util.change_scene_transition(file_scene)


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Options_pressed() -> void:
	Util.change_scene_transition(options_scene)
