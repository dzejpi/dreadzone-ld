extends Node3D

@onready var sprite_a: Sprite3D = $SpriteA
@onready var sprite_b: Sprite3D = $SpriteB

@onready var dust_audio_stream_player_3d: AudioStreamPlayer3D = $DustAudioStreamPlayer3D
const SOUND_BULLET_BANG = preload("res://assets/sfx/sound_bullet_bang.mp3")

var countdown = 1


func _ready() -> void:
	if dust_audio_stream_player_3d:
		dust_audio_stream_player_3d.stream = SOUND_BULLET_BANG
		dust_audio_stream_player_3d.play()


func _process(delta: float) -> void:
	if countdown >= 0:
		countdown -= 1 * delta
		sprite_a.modulate.a = countdown
		sprite_b.modulate.a = countdown
	else:
		queue_free()
