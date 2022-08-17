extends ScrollContainer

export(float, 1.0, 100.0, 1.0) var scroll_distance = 2.0
export(float, 0.1, 2.0, 0.1) var duration = .5
onready var previous_vscroll := scroll_vertical
onready var target_scroll := scroll_vertical


func _on_ScrollContainer_scroll_started() -> void:
	if scroll_vertical > target_scroll:
		target_scroll += scroll_distance
	else:
		target_scroll -= scroll_distance
	scroll_vertical = previous_vscroll
	
	var tween := create_tween()
	tween.tween_property(self, "scroll_vertical", target_scroll, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	previous_vscroll = scroll_vertical


func _on_ScrollContainer_scroll_ended() -> void:
	if scroll_vertical > target_scroll:
		target_scroll += scroll_distance
	else:
		target_scroll -= scroll_distance
	scroll_vertical = previous_vscroll
	
	var tween := create_tween()
	tween.tween_property(self, "scroll_vertical", target_scroll, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	previous_vscroll = scroll_vertical
