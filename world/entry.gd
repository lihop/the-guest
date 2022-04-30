extends Spatial

var _door_opened := false

onready var terminal := $Hinge/Door/WallTerminal


func _ready():
	yield(VM, "console_wrote")
	yield(get_tree().create_timer(3), "timeout")
	$SSHClient.call_deferred("Connect")
	yield($SSHClient, "Connected")
	while has_node("SSHClient") and $SSHClient != null:
		$SSHClient.call_deferred("RunCommand", "who")
		yield($SSHClient, "Outputed")
		yield(get_tree().create_timer(1), "timeout")


func open_door():
	if not _door_opened:
		terminal.call_deferred("release_cam")
		yield(terminal, "cam_released")
		_door_opened = true
		$AnimationPlayer.play("OpenDoor")
		$SSHClient.queue_free()


func _on_MQTTClient_MessageReceived(message):
	match message:
		"root login on 'console'", "guest login on 'console'":
			open_door()
			$MQTTClient.queue_free()


func _on_SSHClient_Outputed(output):
	if "guest" in output:
		open_door()
