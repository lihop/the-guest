extends StaticBody


func on_frob(_player: Player) -> void:
	if not $AudioStreamPlayer3D.playing:
		$AudioStreamPlayer3D.play(0.2)
		$Timer.start()


func _on_Timer_timeout():
	$AudioStreamPlayer3D.stop()
