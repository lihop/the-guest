extends Spatial

export(bool) var player_start := true

var paused := false

onready var player := $Player

var _thread := Thread.new()


func _ready():
	OS.set_window_maximized(true)

	VM.config.net_devices[0].port_forwards = PoolStringArray(
		[
			"tcp:127.0.0.1:%s-0.0.0.0:22" % VM.ssh_port,
			"tcp:127.0.0.1:%s-0.0.0.0:1883" % VM.mqtt_port,
		]
	)
	VM.start()

	yield(VM, "console_wrote")
	yield(get_tree().create_timer(3), "timeout")

	$SSHClient.Connect()
	var err = yield($SSHClient, "Connected")
	if err == OK:
		$SSHClient.RunCommand("date")

	get_tree().call_group("mqtt", "Connect", VM.mqtt_port)

	if player_start:
		for p in get_tree().get_nodes_in_group("player"):
			if p != player:
				p.queue_free()
		player.call_deferred("create_instance", true)


func glitch(won := false):
	$Player.frozen = true
	if won:
		$Glitch/ColorRect/_/Label.text = "YOU WON!"
	$Glitch/ColorRect.visible = true
	$Glitch/AudioStreamPlayer.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_PTY_data_received(data: PoolByteArray) -> void:
	pass


func _on_Node_received_message(topic, message):
	pass


func _on_MQTTClient_MessageReceived(message):
	match message:
		"Early exit: Terminated by signal":
			$Glitch.glitch()


func _on_MQTTClient_Disconnected(reason: String) -> void:
	$Glitch/ColorRect.visible = true
	$Glitch/AudioStreamPlayer.play()


func _on_SSHClient_Outputed(output):
	return


func _on_Auth_MessageReceived(message):
	return


func _on_Audit_MessageReceived(message):
	return


func _on_Area_body_entered(player: Player):
	glitch(true)


func _on_Button2_pressed():
	get_tree().quit()


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not paused:
			paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Player.frozen = true
			$Glitch/AudioStreamPlayer.play()
			$Glitch/ColorRect.visible = true
			$Glitch/ColorRect/_/Label.text = "PAUSED"
		else:
			paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Player.frozen = false
			$Glitch/AudioStreamPlayer.stop()
			$Glitch/ColorRect.visible = false
