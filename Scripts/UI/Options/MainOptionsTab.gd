extends VBoxContainer

func _ready() -> void:
	var cur_conf := WorldController.cur_config
	$MusicCheckbox.pressed = WorldController.cur_config.music
	$FullscreenCheckbox.pressed = WorldController.cur_config.fullscreen
	$BorderlessCheckbox.pressed = WorldController.cur_config.borderless
	$VsyncCheckbox.pressed = WorldController.cur_config.vsync
	$"%MasterVolumeSlider".value = cur_conf.volume_master
	$"%MusicVolumeSlider".value = cur_conf.volume_music
	$"%SfxVolumeSlider".value = cur_conf.volume_sfx
	$ButtonPrompts.selected = cur_conf.button_prompts
	if ($FullscreenCheckbox.toggle_mode):
		$BorderlessCheckbox.toggle_mode = true
	else:
		$BorderlessCheckbox.toggle_mode = false
	$MusicCheckbox.grab_focus()


func _on_MusicCheckbox_toggled(button_pressed: bool) -> void:
	WorldController.cur_config.music = button_pressed
	if (button_pressed):
		WorldController.play_music($"%MusicPlayer".music)
	else:
		WorldController.stop_music()


func _on_FullscreenCheckbox_toggled(button_pressed: bool) -> void:
	WorldController.cur_config.fullscreen = button_pressed
	if (button_pressed):
		$BorderlessCheckbox.disabled = true
	else:
		$BorderlessCheckbox.disabled = false
	OS.window_fullscreen = button_pressed


func _on_BorderlessCheckbox_toggled(button_pressed: bool) -> void:
	WorldController.cur_config.borderless = button_pressed
	OS.window_borderless = button_pressed


func _on_VsyncCheckbox_toggled(button_pressed: bool) -> void:
	WorldController.cur_config.vsync = button_pressed
	OS.vsync_enabled = button_pressed


func _on_MasterVolumeSlider_entered() -> void:
	$"%MasterVolume".add_color_override("font_color", Color.turquoise)


func _on_MasterVolumeSlider_exited() -> void:
	$"%MasterVolume".add_color_override("font_color", Color.white)


func _on_MusicVolumeSlider_entered() -> void:
	$"%MusicVolume".add_color_override("font_color", Color.turquoise)


func _on_MusicVolumeSlider_exited() -> void:
	$"%MusicVolume".add_color_override("font_color", Color.white)


func _on_SfxVolumeSlider_entered() -> void:
	$"%SfxVolume".add_color_override("font_color", Color.turquoise)


func _on_SfxVolumeSlider_exited() -> void:
	$"%SfxVolume".add_color_override("font_color", Color.white)


func _on_MasterVolumeSlider_value_changed(value: float) -> void:
	WorldController.cur_config.volume_master = value
	Util.set_volume("Master", value)


func _on_MusicVolumeSlider_value_changed(value: float) -> void:
	WorldController.cur_config.volume_music = value
	Util.set_volume("Music", value)


func _on_SfxVolumeSlider_value_changed(value: float) -> void:
	WorldController.cur_config.volume_sfx = value
	Util.set_volume("Sfx", value)


func _on_BackKeyboard_pressed() -> void:
	get_parent().current_tab = 0
	$KeyboardSettings.grab_focus()


func _on_BackController_pressed() -> void:
	get_parent().current_tab = 0
	$ControllerSettings.grab_focus()


func _on_ButtonPrompts_item_selected(id):
	WorldController.cur_config.button_prompts = id
