# SPDX-FileCopyrightText: none
# SPDX-License-Identifier: CC0-1.0
extends "res://addons/gd-plug/plug.gd"


func _plugging():
	plug("2nafish117/godot-verlet-rope", {commit = "49ffdf9340cf5a1aebbaa6301bfb938e14ba07a2"})
	plug(
		"jocamar/Godot-Post-Process-Outlines", {commit = "12a9e0e9b2e31ba71c9feb0734e23fab50a00b98"}
	)
	plug(
		"lihop/glam",
		{commit = "b9487c3da06114337c9f30c67112957d284ce0f4", include = ["addons/glam"]}
	)
	plug(
		"lihop/gdtemu",
		{commit = "2950200d21aeda988e1a5328b89d3b5ee57e241e", include = ["addons/gdtemu"]}
	)
	plug("lihop/godot-xterm-dist", {commit = "6534aa3379ef09eca70a3e42539e47fe31ce07e4"})
	plug(
		"Scipioceaser/Godot-Thief-Controller", {commit = "83fd8009f7564ecf910e78314c59d713b0664422"}
	)
	plug("SIsilicon/Godot-3D-text-plugin", {commit = "975e0859bf74cd787567e54d5f84a0d2d903a423"})
	plug("sketchfab/godot-plugin", {commit = "f88e23b03fc398e1c4f08162c9a4c512f2bfc840"})
