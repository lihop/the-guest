extends Node

signal date_changed(new_date)
signal date_s_changed(new_date_s)

var _connected := false
var _date := ""
var _date_s := 0


func _ready():
	yield(VM, "console_wrote")
	yield(get_tree().create_timer(3), "timeout")
	$SSHClient.call_deferred("Connect")
	yield($SSHClient, "Connected")
	$SSHClient.call_deferred("RunCommand", "date -s '2038-01-01'")
	_connected = true


func _on_Tick_timeout():
	if _connected:
		$SSHClient.call_deferred("RunCommand", "date +%s")
		_date_s = int(yield($SSHClient, "Outputed"))
		$SSHClient.call_deferred("RunCommand", 'date +"%Y-%m-%dT%H:%M:%S%"')
		_date = str(yield($SSHClient, "Outputed")).strip_edges()
		emit_signal("date_changed", _date)
		emit_signal("date_s_changed", _date_s)
