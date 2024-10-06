extends Node3D

@onready var minigun_animation_player: AnimationPlayer = $MinigunAnimationPlayer


func turn_barrel():
	minigun_animation_player.play("turn_barrel")
