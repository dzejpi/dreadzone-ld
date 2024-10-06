extends TextureButton


@export var transition_on = true
var is_button_pressed = false
var platform = OS.get_name()


func _ready():
	if platform == "HTML5":
		self.disabled = true


func _process(_delta):
	if is_button_pressed:
		if transition_overlay.transition_completed:
			get_tree().quit()


func _on_pressed():
	is_button_pressed = true
	if transition_on:
		transition_overlay.fade_in()
	global_var.play_sound("select")
