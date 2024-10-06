extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var play_animation = true

func _ready() -> void:
	if play_animation:
		animation_player.play("walking")
