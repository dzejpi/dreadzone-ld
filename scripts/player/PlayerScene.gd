extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var player_camera = $PlayerHead/Camera
@onready var ray_cast = $PlayerHead/Camera/RayCast3D
@onready var shooting_raycast = $PlayerHead/Camera/ShootingCast

# For shotgun
@onready var shooting_cast_2: RayCast3D = $PlayerHead/Camera/ShootingCast2
@onready var shooting_cast_3: RayCast3D = $PlayerHead/Camera/ShootingCast3
@onready var shooting_cast_4: RayCast3D = $PlayerHead/Camera/ShootingCast4
@onready var shooting_cast_5: RayCast3D = $PlayerHead/Camera/ShootingCast5

# UI parts
@onready var game_pause_scene = $PlayerUI/Pause/GamePauseScene
@onready var game_over_scene = $PlayerUI/GameEnd/GameOverScene
@onready var game_won_scene = $PlayerUI/GameEnd/GameWonScene
@onready var player_tooltip = $PlayerUI/GameUI/PlayerTooltip

@onready var player_hands: Node3D = $PlayerHead/Camera/PlayerHands
@onready var weapon_pistol: Node3D = $PlayerHead/Camera/PlayerHands/WeaponPistol
@onready var weapon_rifle: Node3D = $PlayerHead/Camera/PlayerHands/WeaponRifle
@onready var weapon_shotgun: Node3D = $PlayerHead/Camera/PlayerHands/WeaponShotgun
@onready var weapon_machine_gun: Node3D = $PlayerHead/Camera/PlayerHands/WeaponMachineGun
@onready var weapon_minigun: Node3D = $PlayerHead/Camera/PlayerHands/WeaponMinigun

@onready var health_label: Label = $PlayerUI/GameUI/HealthLabel
@onready var score_label: Label = $PlayerUI/GameUI/ScoreLabel
@onready var message_label: Label = $PlayerUI/GameUI/MessageLabel

@onready var weapon_pistol_fire: Node3D = $PlayerHead/Camera/PlayerHands/FirePoints/PistolFire
@onready var weapon_rifle_fire: Node3D = $PlayerHead/Camera/PlayerHands/FirePoints/RifleFire
@onready var weapon_shotgun_fire: Node3D = $PlayerHead/Camera/PlayerHands/FirePoints/ShotgunFire
@onready var weapon_machine_gun_fire: Node3D = $PlayerHead/Camera/PlayerHands/FirePoints/MachineGunFire
@onready var weapon_minigun_fire: Node3D = $PlayerHead/Camera/PlayerHands/FirePoints/MinigunFire

@onready var animation_player: AnimationPlayer = $PlayerHead/AnimationPlayer
@onready var gun_animation_player: AnimationPlayer = $PlayerHead/GunAnimationPlayer

@onready var damage_indicator: Sprite2D = $PlayerUI/GameUI/DamageIndicator

const SOUND_GUNSHOT_A = preload("res://assets/sfx/sound_gunshot_a.mp3")
const SOUND_GUNSHOT_B = preload("res://assets/sfx/sound_gunshot_b.mp3")
const SOUND_GUNSHOT_HEAVY = preload("res://assets/sfx/sound_gunshot_heavy.mp3")
const SOUND_HURT = preload("res://assets/sfx/sound_hurt.mp3")
const SOUND_WEAPON_CHANGE = preload("res://assets/sfx/sound_weapon_change.mp3")

@onready var player_audio_stream_player_3d: AudioStreamPlayer3D = $PlayerAudioStreamPlayer3D

@export var is_fov_dynamic = true

const BLOOD_DECAL = preload("res://scenes/decals/BloodDecal.tscn")
const BULLET_DECAL = preload("res://scenes/decals/BulletDecal.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity = 0.75

var is_game_paused = false
var is_game_over = false
var is_game_won = false

var base_fov = 90
var increased_fov = 94
var current_fov = base_fov
var fov_change_speed = 5

var current_gun = 1

var player_health = 100

var shooting_countdown = 0

var pistol_cadence = 0.3
var rifle_cadence = 0.6
var shotgun_cadence = 1.5
var machine_gun_cadence = 0.1
var minigun_cadence = 0.05

var pistol_damage = 10
var rifle_damage = 20
var shotgun_damage = 30
var machine_damage = 20
var minigun_damage = 20

var is_rifle_available = false
var is_shotgun_available = false
var is_machine_gun_available = false
var is_minigun_available = false

var base_gunfire_effect_countdown = 0.1
var gunfire_effect_countdown = 0

var camera_tilt_amount = 0.1
var camera_tilt_speed = 5

var message_base_countdown = 2
var message_current_countdown = 0

var is_switching_weapon = false
var is_new_weapon_displayed = false
var base_weapon_switch_countdown = 1
var current_weapon_switch_countdown = 0

var base_invincibility_countdown = 2
var current_invincibility_countdown = 0

var debug = true


func _ready():
	global_var.is_player_playing = true
	global_var.current_score = 0
	player_camera.fov = current_fov
	switch_gun(current_gun)
	transition_overlay.fade_out()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_game_paused = false
	game_pause_scene.hide()
	game_over_scene.hide()
	game_won_scene.hide()
	animation_player.play("idle")
	
	# Have all weapons available right away
	if debug:
		is_rifle_available = true
		is_shotgun_available = true
		is_machine_gun_available = true
		is_minigun_available = true


func _process(delta):
	# Unnecessary for now
	#process_collisions()
	
	# Camera tilting, 0 by default
	var camera_tilt_target = 0.0
	
	if is_switching_weapon:
		if current_weapon_switch_countdown > 0:
			current_weapon_switch_countdown -= 1 * delta
			
			# Show new weapon once countdown is under 0.5
			if current_weapon_switch_countdown <= 0.5:
				if !is_new_weapon_displayed:
					is_new_weapon_displayed = true
					
					weapon_pistol.hide()
					weapon_rifle.hide()
					weapon_shotgun.hide()
					weapon_machine_gun.hide()
					weapon_minigun.hide()
					
					match(current_gun):
						1:
							# Pistol
							weapon_pistol.show()
						2:
							# Rifle
							weapon_rifle.show()
						3:
							# Shotgun
							weapon_shotgun.show()
						4:
							# Machine gun
							weapon_machine_gun.show()
						5:
							# Minigun
							weapon_minigun.show()
		else:
			current_weapon_switch_countdown = 0
			is_switching_weapon = false
	
	# Info for creatures to stop
	if is_game_paused or is_game_won or is_game_over:
		global_var.is_player_playing = false
	elif !is_game_paused and !is_game_won and !is_game_over:
		global_var.is_player_playing = true
	
	if Input.is_action_pressed("move_left"):
		camera_tilt_target = camera_tilt_amount
	elif Input.is_action_pressed("move_right"):
		camera_tilt_target = -camera_tilt_amount
	
	var current_cam_rotation = player_camera.rotation.z
	player_camera.rotation.z = lerp_angle(current_cam_rotation, camera_tilt_target, camera_tilt_speed * delta)
	
	
	# Update pause state if the user clicks on Continue
	score_label.text = str(global_var.current_score)
	
	global_var.current_player_position = self.global_transform.origin
	
	if message_current_countdown > 0:
		message_current_countdown -= 1 * delta
		
		# Start modulating once 1 or less
		if message_current_countdown <= 1:
			
			# Make sure it's not less than 0 for modulation
			if message_current_countdown < 0:
				message_current_countdown = 0
			
			message_label.modulate.a = message_current_countdown
	
	if current_invincibility_countdown > 0:
		current_invincibility_countdown -= 1 * delta
		
		# Start fading once it's 1 or less
		if current_invincibility_countdown <= 1:
			# Make sure it's not below 0
			if current_invincibility_countdown <= 0:
				current_invincibility_countdown = 0
			
			damage_indicator.modulate.a = current_invincibility_countdown
	
	if shooting_countdown > 0:
		shooting_countdown -= 1 * delta
	
	if gunfire_effect_countdown > 0:
		gunfire_effect_countdown -= 1 * delta
	else:
		turn_all_fires_down()
	
	if is_game_paused:
		listen_for_pause_button_change()


func _input(event):
	if !is_game_paused && !is_game_over && !is_game_won:
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
			player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	
		if Input.is_action_just_pressed("game_pause"):
			if !is_game_over && !is_game_won:
				if is_game_paused:
					is_game_paused = false
					game_pause_scene.is_game_paused = is_game_paused
				else:
					is_game_paused = true
					game_pause_scene.is_game_paused = is_game_paused
			
			update_pause_state()
			
		if Input.is_action_just_pressed("gun_a"):
			switch_gun(1)
		
		if Input.is_action_just_pressed("gun_b"):
			if is_rifle_available:
				switch_gun(2)
		
		if Input.is_action_just_pressed("gun_c"):
			if is_shotgun_available:
				switch_gun(3)
		
		if Input.is_action_just_pressed("gun_d"):
			if is_machine_gun_available:
				switch_gun(4)
		
		if Input.is_action_just_pressed("gun_e"):
			if is_minigun_available:
				switch_gun(5)
		
		# Autofire for now. Might differentiate later non-automatic guns. 
		if Input.is_action_pressed("gun_shoot"):
			if !is_switching_weapon:
				fire_weapon()


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if !is_switching_weapon:
			animation_player.play("idle")
		
		if Input.is_action_pressed("move_sprint"):
			if !is_game_paused && !is_game_over && !is_game_won:
				velocity.x = direction.x * SPEED * 2
				velocity.z = direction.z * SPEED * 2
				if is_fov_dynamic:
					increase_fov(delta)
			else:
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
				if is_fov_dynamic:
					decrease_fov(delta)
		else:
			if !is_game_paused && !is_game_over && !is_game_won:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				if is_fov_dynamic:
					decrease_fov(delta)
			else:
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
				if is_fov_dynamic:
					decrease_fov(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if is_fov_dynamic:
			decrease_fov(delta)
	
	# Stop any movement when the game is paused/over/won
	if !global_var.is_player_playing:
		velocity = Vector3(0, 0, 0)
	
	move_and_slide()


func process_collisions():
	if ray_cast.is_colliding():
		var current_collider = ray_cast.get_collider()
		if current_collider:
			var collision_object = ray_cast.get_collider().name
			
			if debug:
				print("Player is looking at: " + collision_object + ".")
	else:
		if debug:
			print("Player is looking at: nothing.")


func update_pause_state():
	if is_game_paused:
		game_pause_scene.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		game_pause_scene.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func listen_for_pause_button_change():
	if !(game_pause_scene.is_game_paused):
		is_game_paused = game_pause_scene.is_game_paused
		update_pause_state()


func toggle_game_over():
	is_game_over = true
	game_over_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	transition_overlay.fade_in()


func toggle_game_won():
	is_game_won = true
	game_won_scene.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func increase_fov(delta):
	current_fov = player_camera.fov
	if current_fov < increased_fov:
		current_fov += fov_change_speed * delta
		
		if current_fov > increased_fov:
			current_fov = increased_fov
		
		change_fov(current_fov)


func decrease_fov(delta):
	current_fov = player_camera.fov
	
	if current_fov > base_fov:
		current_fov -= fov_change_speed * delta * 8
		
		if current_fov < base_fov:
			current_fov = base_fov
		
		change_fov(current_fov)


func change_fov(new_fov):
	player_camera.fov = new_fov


func switch_gun(new_gun):
	if current_gun != new_gun:
		current_gun = new_gun
		
		player_audio_stream_player_3d.stream = SOUND_WEAPON_CHANGE
		player_audio_stream_player_3d.play()
		
		animation_player.play("weapon_change")
		
		is_switching_weapon = true
		is_new_weapon_displayed = false
		current_weapon_switch_countdown = base_weapon_switch_countdown


func receive_damage(damage_received):
	if global_var.is_player_playing:
		if current_invincibility_countdown <= 0:
			current_invincibility_countdown = base_invincibility_countdown
			
			
			display_hurt_indicator()
			player_health -= damage_received
			
			player_audio_stream_player_3d.stream = SOUND_HURT
			player_audio_stream_player_3d.play()
			
			if player_health <= 0:
				player_health = 0
				toggle_game_over()
				
			health_label.text = str(player_health)


func receive_health(health_received):
	player_health += health_received
	if player_health > 150:
		player_health = 150
	
	health_label.text = str(player_health)
	show_message("Health picked!")


func show_message(message_text):
	message_label.text = message_text
	message_label.modulate.a = 1
	
	message_current_countdown = message_base_countdown


func gain_gun(gun_number):
	match(gun_number):
		2:
			# Rifle
			is_rifle_available = true
			show_message("Rifle picked!")
		3:
			# Shotgun
			is_shotgun_available = true
			show_message("Shotgun picked!")
		4:
			# Machine gun
			is_machine_gun_available = true
			show_message("Machine gun picked!")
		5:
			# Minigun
			is_minigun_available = true
			show_message("Minigun picked!")


func fire_weapon():
	if shooting_countdown <= 0:
		if debug:
			print("Shooting")
		
		match(current_gun):
			1:
				gun_animation_player.play("shoot_pistol")
				player_audio_stream_player_3d.stream = SOUND_GUNSHOT_B
				player_audio_stream_player_3d.play()
			2:
				gun_animation_player.play("shoot_rifle")
				player_audio_stream_player_3d.stream = SOUND_GUNSHOT_B
				player_audio_stream_player_3d.play()
			3:
				gun_animation_player.play("shoot_shotgun")
				player_audio_stream_player_3d.stream = SOUND_GUNSHOT_HEAVY
				player_audio_stream_player_3d.play()
			4:
				gun_animation_player.play("shoot_machine_gun")
				player_audio_stream_player_3d.stream = SOUND_GUNSHOT_B
				player_audio_stream_player_3d.play()
			4:
				gun_animation_player.play("shoot_minigun")
				player_audio_stream_player_3d.stream = SOUND_GUNSHOT_B
				player_audio_stream_player_3d.play()
		
		set_shooting_countdown()
		show_fire()
		
		if shooting_raycast.is_colliding():
			var current_collider = shooting_raycast.get_collider()
			if current_collider:
				var collision_object = shooting_raycast.get_collider().name
				
				if debug:
					print("Player shot: " + collision_object + ".")
				
				if collision_object != "HardSurface":
					var collision_shape = shooting_raycast.get_collider().get_node("EnemyCollisionShape")
					if collision_shape:
						shooting_raycast.get_collider().receive_damage(100)
						
						var hit_position = shooting_raycast.get_collision_point()
						var hit_normal = shooting_raycast.get_collision_normal()
						var hit_object = shooting_raycast.get_collider()
						
						create_decal(hit_position, hit_normal, "blood")
				elif collision_object == "HardSurface":
					var hit_position = shooting_raycast.get_collision_point()
					var hit_normal = shooting_raycast.get_collision_normal()
					var hit_object = shooting_raycast.get_collider()
					
					create_decal(hit_position, hit_normal, "bullet")
		
		# Multiple shotgun rays
		if current_gun == 3:
			if shooting_cast_2.is_colliding():
				var current_collider = shooting_cast_2.get_collider()
				if current_collider:
					var collision_object = shooting_cast_2.get_collider().name
					
					if debug:
						print("Player shot: " + collision_object + ".")
					
					if collision_object != "HardSurface":
						var collision_shape = shooting_cast_2.get_collider().get_node("EnemyCollisionShape")
						if collision_shape:
							shooting_cast_2.get_collider().receive_damage(100)
							
							var hit_position = shooting_cast_2.get_collision_point()
							var hit_normal = shooting_cast_2.get_collision_normal()
							var hit_object = shooting_cast_2.get_collider()
							
							create_decal(hit_position, hit_normal, "blood")
					elif collision_object == "HardSurface":
						var hit_position = shooting_cast_2.get_collision_point()
						var hit_normal = shooting_cast_2.get_collision_normal()
						var hit_object = shooting_cast_2.get_collider()
						
						create_decal(hit_position, hit_normal, "bullet")
				
			if shooting_cast_3.is_colliding():
				var current_collider = shooting_cast_3.get_collider()
				if current_collider:
					var collision_object = shooting_cast_3.get_collider().name
					
					if debug:
						print("Player shot: " + collision_object + ".")
					
					if collision_object != "HardSurface":
						var collision_shape = shooting_cast_3.get_collider().get_node("EnemyCollisionShape")
						if collision_shape:
							shooting_cast_3.get_collider().receive_damage(100)
							
							var hit_position = shooting_cast_3.get_collision_point()
							var hit_normal = shooting_cast_3.get_collision_normal()
							var hit_object = shooting_cast_3.get_collider()
							
							create_decal(hit_position, hit_normal, "blood")
					elif collision_object == "HardSurface":
						var hit_position = shooting_cast_3.get_collision_point()
						var hit_normal = shooting_cast_3.get_collision_normal()
						var hit_object = shooting_cast_3.get_collider()
						
						create_decal(hit_position, hit_normal, "bullet")
				
			if shooting_cast_4.is_colliding():
				var current_collider = shooting_cast_4.get_collider()
				if current_collider:
					var collision_object = shooting_cast_4.get_collider().name
					
					if debug:
						print("Player shot: " + collision_object + ".")
					
					if collision_object != "HardSurface":
						var collision_shape = shooting_cast_4.get_collider().get_node("EnemyCollisionShape")
						if collision_shape:
							shooting_cast_4.get_collider().receive_damage(100)
							
							var hit_position = shooting_cast_4.get_collision_point()
							var hit_normal = shooting_cast_4.get_collision_normal()
							var hit_object = shooting_cast_4.get_collider()
							
							create_decal(hit_position, hit_normal, "blood")
					elif collision_object == "HardSurface":
						var hit_position = shooting_cast_4.get_collision_point()
						var hit_normal = shooting_cast_4.get_collision_normal()
						var hit_object = shooting_cast_4.get_collider()
						
						create_decal(hit_position, hit_normal, "bullet")
			if shooting_cast_5.is_colliding():
				var current_collider = shooting_cast_5.get_collider()
				if current_collider:
					var collision_object = shooting_cast_5.get_collider().name
					
					if debug:
						print("Player shot: " + collision_object + ".")
					
					if collision_object != "HardSurface":
						var collision_shape = shooting_cast_5.get_collider().get_node("EnemyCollisionShape")
						if collision_shape:
							shooting_cast_5.get_collider().receive_damage(100)
							
							var hit_position = shooting_cast_5.get_collision_point()
							var hit_normal = shooting_cast_5.get_collision_normal()
							var hit_object = shooting_cast_5.get_collider()
							
							create_decal(hit_position, hit_normal, "blood")
					elif collision_object == "HardSurface":
						var hit_position = shooting_cast_5.get_collision_point()
						var hit_normal = shooting_cast_5.get_collision_normal()
						var hit_object = shooting_cast_5.get_collider()
						
						create_decal(hit_position, hit_normal, "bullet")
				

func set_shooting_countdown():
	match(current_gun):
		1:
			shooting_countdown = pistol_cadence
		2:
			shooting_countdown = rifle_cadence
		3:
			shooting_countdown = shotgun_cadence
		4:
			shooting_countdown = machine_gun_cadence
		5:
			shooting_countdown = minigun_cadence


func get_current_damage():
	match(current_gun):
		1:
			return pistol_damage
		2:
			return rifle_damage
		3:
			return shotgun_damage
		4:
			return machine_damage
		5:
			return minigun_damage


func create_decal(position: Vector3, normal: Vector3, decal_type: String):
	if decal_type == "bullet":
		var decal = BULLET_DECAL.instantiate()
		
		get_parent().add_child(decal)
		decal.transform.origin = position
		if abs(normal.dot(Vector3(0, 1, 0))) > 0.99:
			decal.look_at(position + normal, Vector3(1, 0, 0))
			# Not sure why, but it needs to be rotated. Not the blood one, though
			decal.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(90))
		else:
			decal.look_at(position + normal, Vector3.UP)
			# Same
			decal.rotate_object_local(Vector3(1, 0, 0), deg_to_rad(90))
	elif decal_type == "blood":
		var decal = BLOOD_DECAL.instantiate()
		
		get_parent().add_child(decal)
		decal.transform.origin = position
		if abs(normal.dot(Vector3(0, 1, 0))) > 0.99:
			decal.look_at(position + normal, Vector3(1, 0, 0))
		else:
			decal.look_at(position + normal, Vector3.UP)


func show_fire():
	gunfire_effect_countdown = base_gunfire_effect_countdown
	var random_angle = int(randf_range(10, 45))
	
	match(current_gun):
		1:
			weapon_pistol_fire.show()
			weapon_pistol_fire.rotation.z += deg_to_rad(random_angle)
		2:
			weapon_rifle_fire.show()
			weapon_rifle_fire.rotation.z += deg_to_rad(random_angle)
		3:
			weapon_shotgun_fire.show()
			weapon_shotgun_fire.rotation.z += deg_to_rad(random_angle)
		4:
			weapon_machine_gun_fire.show()
			weapon_machine_gun_fire.rotation.z += deg_to_rad(random_angle)
		5:
			weapon_minigun_fire.show()
			weapon_minigun_fire.rotation.z += deg_to_rad(random_angle)


func turn_all_fires_down():
	weapon_pistol_fire.hide()
	weapon_rifle_fire.hide()
	weapon_shotgun_fire.hide()
	weapon_machine_gun_fire.hide()
	weapon_minigun_fire.hide()


func display_hurt_indicator():
	damage_indicator.modulate.a = 1
