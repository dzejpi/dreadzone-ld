extends Decal


var countdown = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if countdown >= 0:
		countdown -= 1 * delta
	else:
		queue_free()
