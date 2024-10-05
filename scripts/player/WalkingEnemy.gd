extends CharacterBody3D


@export var creature_number = 4

@onready var player: CharacterBody3D = $"../PlayerScene"
@onready var enemy_raycast: RayCast3D = $EnemyRaycast

@onready var creature_rat: Node3D = $Creatures/CreatureRat
@onready var creature_frog: Node3D = $Creatures/CreatureFrog
@onready var creature_slug: Node3D = $Creatures/CreatureSlug
@onready var creature_spider: Node3D = $Creatures/CreatureSpider

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var creature_speed = 1
var is_following_player = true

var health = 100

var base_damage_countdown = 2
var damage_coutdown = base_damage_countdown

var frog_score = 20
var rat_score = 10
var slug_score = 10
var spider_score = 100


func _ready() -> void:
	set_creature(creature_number)


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
		if player:
			look_at(player.global_transform.origin)
			velocity = transform.basis.z * -creature_speed
	else:
		velocity.z = 0
	
	move_and_slide()


func seek_player():
	is_following_player = true


func set_creature(creature_no):
	creature_rat.hide()
	creature_frog.hide()
	creature_slug.hide()
	creature_spider.hide()
	
	match(creature_no):
		1:
			creature_rat.show()
		2:
			creature_frog.show()
		3:
			creature_slug.show()
		4:
			creature_spider.show()


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
			# Rat
			return rat_score
		2:
			# Frog
			return frog_score
		3:
			# Slug
			return slug_score
		4:
			# Spider
			return spider_score
