extends Node3D


@onready var a_bars_1: Node3D = $GameWorld/ArenaA/Doors/WorldBars1
@onready var a_bars_2: Node3D = $GameWorld/ArenaA/Doors/WorldBars2

@onready var b_bars_1: Node3D = $GameWorld/ArenaB/Doors/WorldBars1
@onready var b_bars_2: Node3D = $GameWorld/ArenaB/Doors/WorldBars2

@onready var c_bars_1: Node3D = $GameWorld/ArenaC/Doors/WorldBars1
@onready var c_bars_2: Node3D = $GameWorld/ArenaC/Doors/WorldBars2

@onready var d_bars_1: Node3D = $GameWorld/ArenaD/Doors/WorldBars1
@onready var d_bars_2: Node3D = $GameWorld/ArenaD/Doors/WorldBars2

@onready var a_spawners: Node3D = $GameWorld/ArenaA/Spawners
@onready var b_spawners: Node3D = $GameWorld/ArenaB/Spawners
@onready var c_spawners: Node3D = $GameWorld/ArenaC/Spawners
@onready var d_spawners: Node3D = $GameWorld/ArenaD/Spawners

@onready var beginning_arena_a: Area3D = $BeginningArenaA
@onready var beginning_arena_b: Area3D = $BeginningArenaB
@onready var beginning_arena_c: Area3D = $BeginningArenaC
@onready var beginning_arena_d: Area3D = $BeginningArenaD

var is_arena_a_clear = false
var is_arena_b_clear = false
var is_arena_c_clear = false
var is_arena_d_clear = false

var is_player_in_arena_a = false
var is_player_in_arena_b = false
var is_player_in_arena_c = false
var is_player_in_arena_d = false

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
	b_bars_1.toggle_door()
	c_bars_1.toggle_door()
	d_bars_1.toggle_door()


func _process(delta: float) -> void:
	if is_player_in_arena_a and !is_arena_a_clear:
		manage_arena_a_events(delta)
	
	if is_player_in_arena_b and !is_arena_b_clear:
		manage_arena_b_events(delta)
	
	if is_player_in_arena_c and !is_arena_c_clear:
		manage_arena_c_events(delta)
	
	if is_player_in_arena_d and !is_arena_d_clear:
		manage_arena_d_events(delta)


func _on_beginning_arena_a_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_player_in_arena_a:
			is_player_in_arena_a = true
			a_bars_1.toggle_door()


func _on_beginning_arena_b_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_player_in_arena_b:
			is_player_in_arena_b = true
			b_bars_1.toggle_door()


func _on_beginning_arena_c_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_player_in_arena_c:
			is_player_in_arena_c = true
			c_bars_1.toggle_door()


func _on_beginning_arena_d_body_entered(body: Node3D) -> void:
	if body.name == "PlayerScene":
		if !is_player_in_arena_d:
			is_player_in_arena_d = true
			d_bars_1.toggle_door()


func spawn_everywhere(which_spawner, creature_number):
	match(which_spawner):
		"a":
			var spawners = a_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.spawn_creature(creature_number)
		"b":
			var spawners = b_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.spawn_creature(creature_number)
		"c":
			var spawners = c_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.spawn_creature(creature_number)
		"d":
			var spawners = d_spawners.get_children()
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
		"b":
			var spawners = b_spawners.get_children()
			for i in range(spawners.size()):
				if i % nth == 0:
					var child = spawners[i]
					if child.has_method("spawn_creature"):
						child.spawn_creature(creature_number)
		"c":
			var spawners = c_spawners.get_children()
			for i in range(spawners.size()):
				if i % nth == 0:
					var child = spawners[i]
					if child.has_method("spawn_creature"):
						child.spawn_creature(creature_number)
		"d":
			var spawners = d_spawners.get_children()
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
		"b":
			var spawners = b_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.creature_to_spawn = creature_number
					child.continuous_spawn = true
		"c":
			var spawners = c_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.creature_to_spawn = creature_number
					child.continuous_spawn = true
		"d":
			var spawners = d_spawners.get_children()
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
		"b":
			var spawners = b_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.continuous_spawn = false
		"c":
			var spawners = c_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.continuous_spawn = false
		"d":
			var spawners = d_spawners.get_children()
			for child in spawners:
				if child.has_method("spawn_creature"):
					child.continuous_spawn = false


func manage_arena_a_events(delta):
	elapsed_time_a += delta
	
	if trigger_time_a != int(elapsed_time_a):
		trigger_time_a = int(elapsed_time_a)
		trigger_arena_a_event(trigger_time_a)
		print("A trigger time: " + str(trigger_time_a))


func manage_arena_b_events(delta):
	elapsed_time_b += delta
	
	if trigger_time_b != int(elapsed_time_b):
		trigger_time_b = int(elapsed_time_b)
		trigger_arena_b_event(trigger_time_b)
		print("B trigger time: " + str(trigger_time_b))


func manage_arena_c_events(delta):
	elapsed_time_c += delta
	
	if trigger_time_c != int(elapsed_time_c):
		trigger_time_c = int(elapsed_time_c)
		trigger_arena_c_event(trigger_time_c)
		print("C trigger time: " + str(trigger_time_c))


func manage_arena_d_events(delta):
	elapsed_time_d += delta
	
	if trigger_time_d != int(elapsed_time_d):
		trigger_time_d = int(elapsed_time_d)
		trigger_arena_d_event(trigger_time_d)
		print("D trigger time: " + str(trigger_time_d))


func trigger_arena_a_event(event_triggered):
	match(event_triggered):
		5:
			spawn_on_nth("a", 8, 2)
		10:
			spawn_on_nth("a", 4, 2)
		20:
			spawn_on_nth("a", 4, 6)
		30:
			spawn_on_nth("a", 4, 6)
		40:
			spawn_on_nth("a", 2, 6)
		60:
			is_arena_a_clear = true
			a_bars_2.toggle_door()


func trigger_arena_b_event(event_triggered):
	match(event_triggered):
		60:
			is_arena_b_clear = true
			b_bars_2.toggle_door()


func trigger_arena_c_event(event_triggered):
	match(event_triggered):
		60:
			is_arena_c_clear = true
			c_bars_2.toggle_door()


func trigger_arena_d_event(event_triggered):
	match(event_triggered):
		60:
			is_arena_d_clear = true
			d_bars_2.toggle_door()
