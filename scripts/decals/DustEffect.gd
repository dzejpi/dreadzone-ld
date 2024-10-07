extends Node3D

@export var dust_type = 0

@onready var sprite_a: Sprite3D = $SpriteA
@onready var sprite_b: Sprite3D = $SpriteB

@onready var dust_audio_stream_player_3d: AudioStreamPlayer3D = $DustAudioStreamPlayer3D
const SOUND_BULLET_BANG = preload("res://assets/sfx/sound_bullet_bang.mp3")
const SOUND_CREATURE_DYING = preload("res://assets/sfx/sound_creature_dying.mp3")
const SOUND_LIVE_HIT = preload("res://assets/sfx/sound_live_hit.mp3")

var countdown = 1


func _ready() -> void:
	if dust_audio_stream_player_3d:
		if dust_type == 0:
			dust_audio_stream_player_3d.stream = SOUND_BULLET_BANG
		else:
			var random_chance = randi() % 2
			if random_chance == 0:
				dust_audio_stream_player_3d.stream = SOUND_LIVE_HIT
			else:
				dust_audio_stream_player_3d.stream = SOUND_CREATURE_DYING
		
		dust_audio_stream_player_3d.play()


func _process(delta: float) -> void:
	if countdown >= 0:
		countdown -= 1 * delta
		sprite_a.modulate.a = countdown
		sprite_b.modulate.a = countdown
