extends Spatial

var opened := false


func _on_Clock_date_changed(new_date):
	$CSGCombiner2/Label3D.text = new_date


func _on_Clock_date_s_changed(new_date_s: int):
	if not opened and new_date_s >= 2147472000 and new_date_s < 2147558400:
		opened = true
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		$BigDoor.open()
