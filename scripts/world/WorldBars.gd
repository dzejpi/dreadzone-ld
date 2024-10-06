extends Node3D


@export var are_bars_open = false

var closed_position_y = 0.0
var open_position_y = -5.0
var slide_time = 4.0


func toggle_door():
	are_bars_open = not are_bars_open


func _process(delta: float) -> void:
	var target_y = open_position_y if are_bars_open else closed_position_y
	var current_y = transform.origin.y
	
	var new_y = lerp(current_y, target_y, delta * slide_time)
	var new_position = transform.origin
	new_position.y = new_y
	transform.origin = new_position
