extends Node3D


@onready var a_bars_1: Node3D = $GameWorld/ArenaA/Doors/WorldBars1
@onready var a_bars_2: Node3D = $GameWorld/ArenaA/Doors/WorldBars2

@onready var b_bars_1: Node3D = $GameWorld/ArenaB/Doors/WorldBars1
@onready var b_bars_2: Node3D = $GameWorld/ArenaB/Doors/WorldBars2

@onready var c_bars_1: Node3D = $GameWorld/ArenaC/Doors/WorldBars1
@onready var c_bars_2: Node3D = $GameWorld/ArenaC/Doors/WorldBars2

@onready var d_bars_1: Node3D = $GameWorld/ArenaD/Doors/WorldBars1
@onready var d_bars_2: Node3D = $GameWorld/ArenaD/Doors/WorldBars2

@onready var beginning_arena_a: Area3D = $BeginningArenaA


var is_arena_a_clear = false
var is_arena_b_clear = false
var is_arena_c_clear = false
var is_arena_d_clear = false

var is_player_in_arena_a = false
var is_player_in_arena_b = false
var is_player_in_arena_c = false
var is_player_in_arena_d = false


func _ready():
	# Enter all entrance doors
	a_bars_1.toggle_door()
	b_bars_1.toggle_door()
	c_bars_1.toggle_door()
	d_bars_1.toggle_door()


func _process(delta: float) -> void:
	pass


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
