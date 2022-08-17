extends Control

onready var file_scene := preload("res://Rooms/FileSelect.tscn")
onready var options_scene := preload("res://Rooms/Options.tscn")


func _ready() -> void:
	$Layout/StartGame.grab_focus()


func _on_StartGame_pressed() -> void:
	get_tree().change_scene_to(file_scene)


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Options_pressed() -> void:
	get_tree().change_scene_to(options_scene)
