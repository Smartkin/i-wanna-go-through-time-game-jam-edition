extends CanvasLayer

export var ability_frame := 0
export var description := "No description provided."

var player_body = []
onready var n_AnimationPlayer := $AnimationPlayer
onready var n_Description := $Description
onready var n_AbilityIcon := $Node2D/Ability


func _ready() -> void:
	n_AbilityIcon.frame = ability_frame
	n_Description.text = description
	n_AnimationPlayer.play("appear")
	$Collected.play()
	
	player_body = get_tree().get_nodes_in_group("Player")
	
	if player_body.size() > 0:
		player_body[0]._switch_state(player_body[0].STATE.CUTSCENE)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("shoot"):
		n_AnimationPlayer.play("dissapear")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "dissapear":
		if player_body.size() > 0:
			player_body[0]._revert_state()
		queue_free()
