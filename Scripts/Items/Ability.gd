tool
class_name Ability
extends Sprite


enum ABILITIES {
	DOUBLE_JUMP,
	SHOOT,
	DASH,
	DOT_KID,
	BOUNCY_BULLETS,
	CRIT_SHOTS,
	HEALTH_1,
	HEALTH_2,
	HEALTH_3,
	HEALTH_4,
	HEALTH_5,
	GUN_1,
	GUN_2,
	GUN_3,
	GUN_4,
	INVALID = -1
}
export(ABILITIES) var id = ABILITIES.INVALID

func _ready():
	if id == ABILITIES.INVALID:
		return
	_change_sprite()

func _process(delta: float):
	if Engine.editor_hint and id != ABILITIES.INVALID:
		_change_sprite()

func _change_sprite():
	if (not range(ABILITIES.HEALTH_1, ABILITIES.GUN_4 + 1).has(id)):
		frame = id
	else:
		if (range(ABILITIES.HEALTH_1, ABILITIES.HEALTH_5 + 1).has(id)):
			frame = 6
		else:
			frame = 7


func _on_scene_built() -> void:
	if Engine.editor_hint:
		return
	if WorldController.check_item(id) and id != ABILITIES.INVALID:
		queue_free()

func _on_Area2D_body_entered(body):
	if id == ABILITIES.INVALID or Engine.editor_hint:
		return
	if (range(ABILITIES.HEALTH_1, ABILITIES.HEALTH_5 + 1).has(id)):
		WorldController.add_health_to_player()
	if (range(ABILITIES.GUN_1, ABILITIES.GUN_4 + 1).has(id)):
		WorldController.cur_save_data.gun_power += 1
	WorldController.save_item(id)
#	WorldController.save_game()
	queue_free()
