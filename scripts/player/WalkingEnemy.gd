extends CharacterBody3D


@export var creature_number = 4

@onready var player: CharacterBody3D = $"../PlayerScene"
@onready var enemy_raycast: RayCast3D = $EnemyRaycast

@onready var creature_rat: Node3D = $Creatures/CreatureRat
@onready var creature_frog: Node3D = $Creatures/CreatureFrog
@onready var creature_slug: Node3D = $Creatures/CreatureSlug
@onready var creature_spider: Node3D = $Creatures/CreatureSpider


var creature_speed = 1
var is_following_player = true

var health = 100

var damage_coutdown = 60


func _ready() -> void:
	set_creature(creature_number)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if is_following_player:
		look_at(player.global_transform.origin)
		velocity = transform.basis.z * -creature_speed
		move_and_slide()
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
	pass
