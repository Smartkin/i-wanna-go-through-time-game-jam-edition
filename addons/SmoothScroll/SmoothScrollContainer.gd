## Smooth scroll functionality for ScrollContainer
##
## Applies velocity based momentum and "overdrag"
## functionality to a ScrollContainer
extends ScrollContainer

# Drag impact for one scroll input
export(float, 100, 1000) var speed = 200
# The friction of the scroll
export(float, 5, 30) var friction = 10
# How quick the scroll bar returns when overshot
export(float, 10, 100) var pullback = 30
# Drag impact from device input
export(float, 100, 1000) var device_speed = 450


# Current velocity of the `content_node`
var velocity := Vector2(0,0)
# Below this value, velocity is set to `0`
var just_stop_under := 0.01
# Current counterforce for "overdragging" on the top
var over_drag_multiplicator_top := 1
# Current counterforce for "overdragging" on the bottom
var over_drag_multiplicator_bottom := 1
# Control node to move when scrolling
var content_node : Control
# Current position of `content_node`
var pos := Vector2(0, 0)
# When true, `content_node`'s position is only set by dragging the scroll bar
var scrolling := false


func _ready() -> void:
	get_v_scrollbar().connect("scrolling", self, "_on_VScrollBar_scrolling")
	content_node = get_child(0)


func _process(delta: float) -> void:
	# If no scroll needed, don't apply forces
	if content_node.rect_size.y - self.rect_size.y < 1:
		return
	
	# Distance between content_node's bottom and bottom of the scroll box 
	var bottom_distance:= content_node.rect_position.y + content_node.rect_size.y - self.rect_size.y
	# Distance between content_node and top of the scroll box
	var top_distance:= content_node.rect_position.y
	
	# Check for joystick or keyboard input
	if Input.is_action_just_pressed("down") and bottom_distance > 0:
		velocity.y -= device_speed
	if Input.is_action_just_pressed("up") and top_distance < 0:
		velocity.y += device_speed
	
	# Simulate friction
	velocity = velocity.move_toward(Vector2.ZERO, (velocity.length()*friction) * delta)
	
	# If velocity is too low, just set it to 0
	if velocity.length() <= just_stop_under:
		velocity = Vector2(0,0)
	
	# Applies counterforces when overdragging
	if bottom_distance< 0 :
		pos.y = pos.move_toward(Vector2(0.0, -bottom_distance), (-bottom_distance*pullback) * delta).y
	if top_distance> 0:
		pos.y = pos.move_toward(Vector2(0.0, -top_distance), (top_distance*pullback) * delta).y
	
	# If using scroll bar dragging, set the content_node's
	# position by using the scrollbar position
	if scrolling:
		pos = content_node.rect_position
		return
	
	# Move content node by applying velocity
	pos += velocity * delta
	content_node.rect_position = pos
	
	# Update vertical scroll bar
	set_v_scroll(-pos.y)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed:
			scrolling = false
		
		match event.button_index:
			BUTTON_WHEEL_DOWN:  velocity.y -= speed
			BUTTON_WHEEL_UP:    velocity.y += speed


func _on_VScrollBar_scrolling() -> void:
	scrolling = true


# Scrolls up a page
func scroll_page_up() -> void:
	velocity.y += self.rect_size.y / 10


# Scrolls down a page
func scroll_page_down() -> void:
	velocity.y -= self.rect_size.y / 10


# Adds velocity to the vertical scroll
func scroll_vertical(amount: float) -> void:
	velocity.y -= amount

# Scrolls to top
func scroll_to_top() -> void:
	# Reset velocity
	velocity.y = 0
	# Move content node to top
	pos.y = 0
	content_node.rect_position = pos
	# Update vertical scroll bar
	set_v_scroll(-pos.y)


# Scrolls to bottom
func scroll_to_bottom() -> void:
	# Reset velocity
	velocity.y = 0
	# Move content node to bottom
	pos.y = -content_node.rect_size.y + self.rect_size.y
	content_node.rect_position = pos
	# Update vertical scroll bar
	set_v_scroll(-pos.y)
