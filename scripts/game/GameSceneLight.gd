extends Node3D


@onready var a_bars_1: Node3D = $GameWorld/ArenaA/Doors/WorldBars1
@onready var a_bars_2: Node3D = $GameWorld/ArenaA/Doors/WorldBars2

@onready var a_spawners: Node3D = $GameWorld/ArenaA/Spawners

@onready var beginning_arena_a: Area3D = $BeginningArenaA

@onready var player_scene: CharacterBody3D = $CharacterBodies/PlayerScene
@onready var pickups: Node3D = $GameWorld/Pickups
@onready var pickup_gun: Node3D = $GameWorld/Pickups/PickupGun


const WORLD_GUN_PICKUP = preload("res://scenes/world/WorldGunPickup.tscn")
const WORLD_HEALTH_PICKUP = preload("res://scenes/world/WorldHealthPickup.tscn")


var is_arena_a_clear = false

var is_player_in_arena_a = false

var elapsed_time_a = 0.0
var trigger_time_a = 0

var elapsed_time_b = 0.0
var trigger_time_b = 0

var elapsed_time_c = 0.0
var trigger_time_c = 0

var elapsed_time_d = 0.0
var trigger_time_d = 0


func _ready():
	# Enter all entrance doors
	a_bars_1.toggle_door()


func _process(delta: float) -> void:
	#print("Number of nodes in the scene: ", str(get_tree().get_node_count()))

	if is_player_in_arena_a and !is_arena_a_clear:
		manage_arena_a_events(delta)


func _on_beginning_arena_a_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_player_in_arena_a:
			is_player_in_arena_a = true
			a_bars_1.toggle_door()


func spawn_everywhere(which_spawner, creature_number):
	match(which_spawner):
		"a":
			var spawners = a_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.spawn_creature(creature_number)


# Function to spawn creature on every Nth spawner
func spawn_on_nth(which_spawner, nth, creature_number):
	match(which_spawner):
		"a":
			var spawners = a_spawners.get_children()
			for i in range(spawners.size()):
				if i % nth == 0:
					var child = spawners[i]
					if child.has_method("spawn_creature"):
						child.spawn_creature(creature_number)


func turn_all_spawners_on(which_spawner, creature_number):
	match(which_spawner):
		"a":
			var spawners = a_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.creature_to_spawn = creature_number
					child.continuous_spawn = true


func turn_all_spawners_off(which_spawner):
	match(which_spawner):
		"a":
			var spawners = a_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.continuous_spawn = false


func manage_arena_a_events(delta):
	if global_var.is_player_playing:
		elapsed_time_a += delta
		
		if trigger_time_a != int(elapsed_time_a):
			trigger_time_a = int(elapsed_time_a)
			trigger_arena_a_event(trigger_time_a)
			#print("A trigger time: " + str(trigger_time_a))


func trigger_arena_a_event(event_triggered):
	match(event_triggered):
		5:
			spawn_health()
			spawn_on_nth("a", 8, 2)
		10:
			spawn_on_nth("a", 4, 4)
		20:
			spawn_on_nth("a", 4, 6)
		30:
			spawn_gun(2)
			spawn_on_nth("a", 4, 6)
		40:
			spawn_on_nth("a", 2, 6)
		60:
			spawn_health()
			global_var.enemy_speed_multiplier = 1.2
		65:
			spawn_on_nth("a", 8, 2)
		70:
			spawn_on_nth("a", 4, 4)
		80:
			spawn_on_nth("a", 4, 6)
		90:
			spawn_gun(3)
			global_var.enemy_speed_multiplier = 1.3
			spawn_on_nth("a", 4, 6)
		100:
			spawn_on_nth("a", 1, 2)
		110:
			spawn_health()
			spawn_on_nth("a", 1, 2)
		120:
			spawn_on_nth("a", 1, 4)
			global_var.enemy_speed_multiplier = 1.4
		130:
			spawn_on_nth("a", 1, 6)
		140:
			spawn_on_nth("a", 1, 2)
		150:
			spawn_gun(4)
		170:
			spawn_on_nth("a", 2, 6)
		180:
			spawn_health()
			spawn_on_nth("a", 2, 4)
		190:
			spawn_health()
			spawn_on_nth("a", 2, 6)
		200:
			spawn_on_nth("a", 2, 4)
		240:
			spawn_on_nth("a", 2, 4)
		260:
			spawn_gun(5)
		270:
			turn_all_spawners_on("a", 6)
			global_var.enemy_speed_multiplier = 1.5
		300:
			turn_all_spawners_off("a")
			spawn_on_nth("a", 1, 2)
		320:
			global_var.enemy_speed_multiplier = 2
			turn_all_spawners_on("a", 6)
		400:
			global_var.enemy_speed_multiplier = 4
			turn_all_spawners_on("a", 6)


func heal_player(amount):
	player_scene.receive_health(amount)


func give_player_gun(gun_number):
	player_scene.gain_gun(gun_number)


func spawn_health():
	var new_health = WORLD_HEALTH_PICKUP.instantiate()
	pickups.add_child(new_health)
	player_scene.show_message("Health dropped!")


func spawn_gun(gun_number):
	var new_gun_pickup = WORLD_GUN_PICKUP.instantiate()
	pickup_gun.add_child(new_gun_pickup)
	new_gun_pickup.set_gun(gun_number)
	player_scene.show_message("New gun dropped!")
