extends TextureButton


@onready var main_menu_scene = $"../../.."


func _on_pressed():
	main_menu_scene.current_focus = "credits"
	release_focus()
	global_var.play_sound("select")
