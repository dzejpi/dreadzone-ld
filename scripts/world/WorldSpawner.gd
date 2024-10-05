extends Node3D


@export var creature_to_spawn = 6
@export var continuous_spawn = false
@export var continuous_spawn_time = 6

@onready var spawn_point: Node3D = $SpawnPoint

const FLYING_ENEMY = preload("res://scenes/player/FlyingEnemy.tscn")
const WALKING_ENEMY = preload("res://scenes/player/WalkingEnemy.tscn")

var spawn_countdown = 0


func _process(delta: float) -> void:
	if continuous_spawn:
		if spawn_countdown <= 0:
			spawn_creature(creature_to_spawn)
			spawn_countdown = continuous_spawn_time
		else:
			spawn_countdown -= 1 * delta


func spawn_creature(creature_number):
	match(creature_number):
		1:
			# Firefly
			var firefly_instance = FLYING_ENEMY.instantiate()
			add_child(firefly_instance)
			firefly_instance.set_creature(1)
			firefly_instance.global_transform.origin = spawn_point.global_transform.origin
		2:
			# Frog
			var frog_instance = WALKING_ENEMY.instantiate()
			add_child(frog_instance)
			frog_instance.set_creature(2)
			frog_instance.global_transform.origin = spawn_point.global_transform.origin
		3:
			# Hornet
			var hornet_instance = FLYING_ENEMY.instantiate()
			add_child(hornet_instance)
			hornet_instance.set_creature(2)
			hornet_instance.global_transform.origin = spawn_point.global_transform.origin
		4:
			# Rat
			var rat_instance = WALKING_ENEMY.instantiate()
			add_child(rat_instance)
			rat_instance.set_creature(1)
			rat_instance.global_transform.origin = spawn_point.global_transform.origin
		5:
			# Slug
			var slug_instance = WALKING_ENEMY.instantiate()
			add_child(slug_instance)
			slug_instance.set_creature(3)
			slug_instance.global_transform.origin = spawn_point.global_transform.origin
		6:
			# Spider
			var spider_instance = WALKING_ENEMY.instantiate()
			add_child(spider_instance)
			spider_instance.set_creature(4)
			spider_instance.global_transform.origin = spawn_point.global_transform.origin
