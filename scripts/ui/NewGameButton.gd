extends TextureButton


var is_button_pressed = false


func _process(_delta):
	if is_button_pressed:
		if transition_overlay.transition_completed:
			get_tree().change_scene_to_file("res://scenes/game/GameSceneLight.tscn")


func _on_pressed():
	transition_overlay.fade_in()
	is_button_pressed = true
	global_var.play_sound("select")
	global_var.play_music()
