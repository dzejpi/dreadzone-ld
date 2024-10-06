extends Node3D


@onready var game_scene: Node3D = $"../../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_health_pickup_area_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		game_scene.heal_player(50)
		queue_free()
