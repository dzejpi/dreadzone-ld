extends CharacterBody3D


@export var creature_number = 1

@onready var enemy_raycast: RayCast3D = $EnemyRaycast

@onready var creature_firefly: Node3D = $Creatures/CreatureFirefly
@onready var creature_hornet: Node3D = $Creatures/CreatureHornet


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var creature_speed = 1
var is_following_player = true

var health = 100

var base_damage_countdown = 2
var damage_coutdown = base_damage_countdown

var firefly_score = 20
var hornet_score = 20


func _process(delta: float) -> void:
	if damage_coutdown > 0:
		damage_coutdown -= 1 * delta
	
	if enemy_raycast.is_colliding():
		var collision_object = enemy_raycast.get_collider().name
		if collision_object == "PlayerScene":
			print("Enemy is looking at player")
			
			if damage_coutdown <= 0:
				enemy_raycast.get_collider().receive_damage(10)
				damage_coutdown = base_damage_countdown


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta * 8
	
	if is_following_player:
		look_at(global_var.current_player_position)
		velocity = transform.basis.z * -creature_speed
	else:
		velocity.z = 0
	
	move_and_slide()


func seek_player():
	is_following_player = true


func set_creature(creature_no):
	creature_firefly.hide()
	creature_hornet.hide()
	
	match(creature_no):
		1:
			creature_firefly.show()
		2:
			creature_hornet.show()


func receive_damage(damage_received):
	health -= damage_received
	if health <= 0:
		die()


func die():
	global_var.current_score += 20
	global_var.current_enemies_killed += 1
	
	queue_free()


func get_creature_score():
	match(creature_number):
		1:
			# Firefly
			return firefly_score
		2:
			# Frog
			return hornet_score
