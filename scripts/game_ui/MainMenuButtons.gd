extends TextureButton


@export var transition_on = true
var is_button_pressed = false


func _process(_delta):
	if is_button_pressed:
		if transition_overlay.transition_completed:
			get_tree().change_scene_to_file("res://scenes/ui/MainMenuScene.tscn")


func _on_pressed():
	is_button_pressed = true
	if transition_on:
		transition_overlay.fade_in()
	global_var.play_sound("select")
