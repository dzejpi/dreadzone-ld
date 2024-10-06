extends Node


@onready var music_node = $MusicPlayer
@onready var sfx_node = $SfxPlayer

var current_score = 0
var current_enemies_killed = 0

var record_score = 0
var record_enemies_killed = 0

# Necessary to replace null with a proper preload("res://...")
var music_game_music = null

# Necessary to replace null with a proper preload("res://...")
const SOUND_SELECT = preload("res://assets/sfx/sound_select.mp3")
const SOUND_PICKING_UP = preload("res://assets/sfx/sound_picking_up.mp3")

const MUSIC_DREADZONE = preload("res://assets/music/music_dreadzone.mp3")

var current_player_position = Vector3()

var is_player_playing = true


func play_music():
	music_node.stream = MUSIC_DREADZONE
	music_node.play()


func stop_music():
	music_node.stop()


func play_sound(sfx_name):
	match(sfx_name):
		"select":
			sfx_node.stream = SOUND_SELECT
			sfx_node.play()
		"pick_up":
			sfx_node.stream = SOUND_PICKING_UP
			sfx_node.play()


func stop_sound(sfx_name):
	match(sfx_name):
		"placeholder":
			sfx_node.stream = SOUND_SELECT
			sfx_node.stop()


func add_score(amount):
	current_score += amount
	
	if current_score > record_score:
		record_score = current_score
