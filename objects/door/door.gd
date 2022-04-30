extends Spatial

var frobbed = false

export(bool) var partial := false


func on_frob(_player: Player) -> void:
	if frobbed:
		return

	frobbed = true
	if partial:
		$AnimationPlayer.play("OpenDoorPartial")
	else:
		$AnimationPlayer.play("OpenDoor")
	$CollisionShape.disabled = true
