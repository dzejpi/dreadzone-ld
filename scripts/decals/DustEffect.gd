extends Node3D

@onready var sprite_a: Sprite3D = $SpriteA
@onready var sprite_b: Sprite3D = $SpriteB

var countdown = 1


func _process(delta: float) -> void:
	if countdown >= 0:
		countdown -= 1 * delta
		sprite_a.modulate.a = countdown
		sprite_b.modulate.a = countdown
	else:
		queue_free()
