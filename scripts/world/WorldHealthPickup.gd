extends Node3D


@onready var game_scene: Node3D = $"../../.."


func _process(delta: float) -> void:
	pass


func _on_health_pickup_area_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		game_scene.heal_player(50)
		queue_free()
