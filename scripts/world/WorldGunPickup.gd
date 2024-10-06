extends Node3D


@export var gun_number = 2

@onready var game_scene = $"../../../.."
@onready var machine_gun_pickup: Node3D = $MachineGunPickup
@onready var minigun_pickup: Node3D = $MinigunPickup
@onready var rifle_pickup: Node3D = $RiflePickup
@onready var shotgun_pickup: Node3D = $ShotgunPickup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(gun_number):
		2:
			rifle_pickup.show()
		3:
			shotgun_pickup.show()
		4:
			machine_gun_pickup.show()
		5:
			minigun_pickup.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_gun(new_gun_number):
	match(new_gun_number):
		2:
			rifle_pickup.show()
			gun_number = new_gun_number
		3:
			shotgun_pickup.show()
			gun_number = new_gun_number
		4:
			machine_gun_pickup.show()
			gun_number = new_gun_number
		5:
			minigun_pickup.show()
			gun_number = new_gun_number


func _on_gun_pickup_area_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		game_scene.give_player_gun(gun_number)
		global_var.play_sound("pick_up")
		queue_free()
