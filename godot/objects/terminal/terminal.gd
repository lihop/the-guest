tool
extends StaticBody

signal frobbed
signal cam_released

var frobber: Player

var _player_cam: Camera
var _original_pos: Transform
var _cam_locked := false

onready var _cam_tween := $CamTween

export(Vector2) var screen_size := Vector2(1920, 1080) setget set_screen_size
export(bool) var use_hvc := false


func _ready():
	if not use_hvc:
		return

	var vms = get_tree().get_nodes_in_group("vm")
	if not vms.empty():
		var vm = vms[0]
		vm.connect("console_wrote", $Viewport/Terminal, "write")
		# warning-ignore:return_value_discarded
		$Viewport/Terminal.connect("data_sent", vm, "console_read")


func _input(event):
	if not _player_cam or not frobber:
		return

	if event is InputEventKey:
		get_tree().set_input_as_handled()
		$Viewport.input(event)

	if _cam_locked:
		return

	if event.is_action_pressed("mouse_left") or event.is_action_pressed("mouse_right"):
		get_tree().set_input_as_handled()
		release_cam()


func release_cam():
	if not _player_cam or not frobber or _cam_locked:
		return

	_cam_locked = true
	$Viewport/Terminal.release_focus()
	_cam_tween.stop_all()
	_cam_tween.interpolate_property(
		_player_cam,
		"global_transform",
		_player_cam.global_transform,
		_original_pos,
		0.5,
		Tween.TRANS_QUAD
	)
	_cam_tween.start()
	yield(_cam_tween, "tween_all_completed")
	_player_cam = null
	_original_pos = Transform()
	_cam_locked = false
	frobber.release_camera()
	frobber = null
	emit_signal("cam_released")


func set_screen_size(value: Vector2) -> void:
	screen_size = value
	$Sprite3D.centered = false
	$Viewport.size = screen_size
	$Sprite3D.centered = true
	$Screen.mesh.size = $Sprite3D.get_item_rect().size


func on_frob(player: Player):
	emit_signal("frobbed")
	_cam_locked = true
	$Viewport/Terminal.grab_focus()
	frobber = player
	_player_cam = frobber.steal_camera()
	_original_pos = _player_cam.global_transform
	_cam_tween.stop_all()
	_cam_tween.interpolate_property(
		_player_cam,
		"global_transform",
		_player_cam.global_transform,
		$Camera.global_transform,
		0.5,
		Tween.TRANS_QUAD
	)
	_cam_tween.start()
	yield(_cam_tween, "tween_all_completed")
	_cam_locked = false
