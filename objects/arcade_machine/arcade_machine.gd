extends "res://objects/terminal/terminal.gd"

const PTY := preload("res://addons/godot_xterm/nodes/pty/pty.gd")
const TPut := preload("res://addons/godot_xterm/util/tput.gd")

onready var tput := TPut.new($Viewport/Terminal)
onready var id_rsa := ProjectSettings.globalize_path("user://id_rsa")

var _pid := 0
var _has_ssh := false


func _ready():
	_has_ssh = OS.execute("which", ["ssh"]) == 0 and OS.execute("which", ["chmod"]) == 0
	if _has_ssh:
		# Copy ssh key to user:// so it can be read by ssh.
		var dir := Directory.new()
		if dir.copy("res://vm/id_rsa", id_rsa) != OK:
			return out_of_order()
		# Ensure file permissions are not too open.
		if OS.execute("chmod", ["600", id_rsa]) != 0:
			return out_of_order()

		yield(VM, "console_wrote")

		var err = $PTY.fork(
			"ssh",
			[
				"-o",
				"StrictHostKeyChecking=no",
				"-o",
				"UpdateHostKeys=no",
				"-p",
				str(VM.ssh_port),
				"-i",
				id_rsa,
				"root@127.0.0.1",
			]
		)
		yield($PTY, "data_received")
		$PTY.write("TERM=linux ascii_invaders\n")
		if err != OK:
			out_of_order()
	else:
		out_of_order()


func out_of_order():
	tput.cup(25, 25)
	$Viewport/Terminal.write("OUT OF ORDER - SORRY :(")


func _on_PTY_data_received(data):
	pass


func _on_PTY_exited(_exit_code, _signum):
	_has_ssh = false
	out_of_order()


func _exit_tree():
	if _has_ssh:
		# Hack! Kill faster! Otherwise game takes a long time if we call $PTY.kill()
		# and never exits at all if we don't do anything.
		# warning-ignore:return_value_discarded
		OS.execute("kill", ["-9", $PTY._pid])
		$PTY.free()
		# Cleanup.
		# warning-ignore:return_value_discarded
		Directory.new().remove(id_rsa)
