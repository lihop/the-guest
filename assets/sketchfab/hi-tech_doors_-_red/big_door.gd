extends StaticBody

var open := false


func open():
	if not open:
		open = true
		$AnimationPlayer.play("OpenDoor")
