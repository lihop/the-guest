tool
extends "res://addons/gdtemu/virtual_machine.gd"

const Port := preload("res://addons/gdtemu/util/port.gd")

onready var ssh_port := Port.get_unused_port(3077)
onready var mqtt_port := Port.get_unused_port(5077)


func _ready():
	# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_on_window_size_changed")


func _on_window_size_changed():
	# Refresh all terminals.
	if is_inside_tree():
		for terminal in get_tree().get_nodes_in_group("terminal"):
			pass  # TODO: Figure how.
