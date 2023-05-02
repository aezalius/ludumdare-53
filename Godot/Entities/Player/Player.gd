extends CharacterBody2D
class_name Player


@export var respawn_location: Vector2 = Vector2(-327,-28)

##
# Misc
@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var interact_area = $InteractArea
@onready var inner_light = $InnerLight
@onready var mid_light = $MidLight
@onready var outer_light = $OuterLight
@onready var camera = $Camera2D
@onready var direction_pointer = $DirectionPointer
@onready var immunity_timer = $ImmunityTimer
@onready var hit_audio_player = $HitAudioPlayer
@onready var walk_audio_player = $WalkAudioPlayer

@onready var dialogue_audio_player = $DialogueAudioPlayer

##
# Package related stuff, to be reworked
@onready var package_sprite = $PackageSprite
@onready var package_scene = preload("res://Entities/Interactables/Package/droppedpackage.tscn")

##
# Cinematic stuff
const camera_zoom_normal: Vector2 = Vector2(2, 2)
const camera_zoom_in: Vector2 = Vector2(3, 3)
var camera_target_zoom: Vector2 = camera_zoom_normal

##
# Movement variables
const SPEED = 150.0
var movement_input_enabled = true

##
# Rolling variables
const ROLL_ACCEL_MULT = 2.0
var roll_influence_amount = 0.5
var is_rolling = false
var can_roll = true
@onready var roll_timer: Timer = $RollTimer
@onready var roll_cooldown: Timer = $RollCooldown

##
# Hitpoints
@export var max_hp: int = 3
@export var cur_hp: int = 3

#
# Called when the node is instanced
func _ready():
	GameHandler.player_instance = self
	
	QuestHandler.stop_movement.connect(stop_movement)
	QuestHandler.free_movement.connect(free_movement)
	roll_timer.set_wait_time(0.3)
	roll_timer.connect("timeout", func(): is_rolling = false; free_movement())
	roll_cooldown.set_wait_time(0.4)
	roll_cooldown.connect("timeout", func(): can_roll = true)

func camera_cinematic_zoom():
	camera_target_zoom = camera_zoom_in

func camera_normal_zoom():
	camera_target_zoom = camera_zoom_normal

#
# Locks the player movement
func stop_movement():
	movement_input_enabled = false

#
# Unlocks the player movement
func free_movement():
	movement_input_enabled = true

#
# Main process for the player, handles movement and most inputs
func _physics_process(_delta):
	## Fast debug quit
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
	
	if QuestHandler.active_quest != null:
		direction_pointer.global_rotation = global_position.direction_to(QuestHandler.active_quest.get_target_location()).angle() + 90
	
	## Camera zooming (Zoom in camera in certain areas, collision layer 24)
	if camera.zoom != camera_target_zoom:
		camera.zoom = camera.zoom.lerp(camera_target_zoom, 0.1)
		
	## Interactions
	if Input.is_action_just_pressed("interact"):
		# trigger interact on bodies
		for body in interact_area.get_overlapping_bodies():
			if body.is_in_group("questgiver"):
				body.interact(package_sprite.visible)
			elif body.is_in_group("deliveryclient"):
				if package_sprite.visible and not QuestHandler.active_quest.quest_turned_in and body == QuestHandler.active_quest.client:
					QuestHandler.active_quest.complete_current_encounter()
					package_sprite.hide()
					#QuestHandler.active_quest.quest_turned_in = true
					print("Quest turned in")
				body.interact()
		
		# Temporary package handling
		if movement_input_enabled:
			if not package_sprite.visible and immunity_timer.is_stopped():
				for body in interact_area.get_overlapping_bodies():
					if body.is_in_group("package"):
						QuestHandler.active_quest.encounter_stack_idx += 1
						immunity_timer.start()
						package_sprite.show()
						body.queue_free()
						cur_hp = max_hp
			else:
				pass
	
	
	## Movement, fairly standard with rolling added
	var direction = Input.get_vector("left","right","up", "down");
	var new_velocity = direction * SPEED # needed to allow for rolling while movement input is disabled
	
	if movement_input_enabled:
		if Input.is_action_just_pressed("roll") and can_roll:
			is_rolling = true
			stop_movement()
			anim_player.play("Dash")
			walk_audio_player.play()
			can_roll = false
			roll_timer.start()
			roll_cooldown.start() # apparently cannot be called in a function called elsewhere, huh
		
		# If the player is rolling, multiply their velocity by the accel amount
		if is_rolling:
			new_velocity *= ROLL_ACCEL_MULT
		
		if new_velocity != Vector2.ZERO:
			if not is_rolling and cur_hp > 0:
				anim_player.play("Walking")
				if not walk_audio_player.is_playing():
					walk_audio_player.play()
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		else:
			anim_player.play("Standing")
		
		velocity = new_velocity
		
	# if the player is rolling, allow some control
	elif is_rolling:
		if new_velocity != Vector2.ZERO:
			new_velocity *= ROLL_ACCEL_MULT
			velocity = velocity.slerp(new_velocity, roll_influence_amount)
	else:
		velocity = Vector2.ZERO
	
	# apply velocity
	move_and_slide()
	
	camera.global_position = camera.global_position.slerp(global_position - (velocity/20), .4)
	inner_light.global_position = inner_light.global_position.slerp(sprite.global_position - (velocity/20), .125) 
	mid_light.global_position = mid_light.global_position.slerp(sprite.global_position - (velocity/20), .15) 
	outer_light.global_position = outer_light.global_position.slerp(sprite.global_position - (velocity/20), .225) 

#
# UNUSED
# player drops package if he is hit, player can take 1 hit if he isnt holding a package
func damage():
	# I-Frames
	if immunity_timer.is_stopped():
		immunity_timer.start()
		hit_audio_player.play()
		if not package_sprite.visible:
			cur_hp -= 1
			if cur_hp <= 0:
				cur_hp = max_hp # temp
				stop_movement()
				anim_player.play("Death")
				$DeathMoveTimer.start()
		else:
			var new_package: Node2D = package_scene.instantiate()
			new_package.global_position = package_sprite.global_position
			get_tree().root.add_child(new_package)
			package_sprite.visible = false
			if QuestHandler.active_quest.encounter_stack_idx > 0: # Probably going to cause some funny bugs
				QuestHandler.active_quest.encounter_stack_idx -= 1



func _on_cinematic_area_detector_area_entered(_area):
	camera_cinematic_zoom()

func _on_cinematic_area_detector_area_exited(_area):
	camera_normal_zoom()


func _on_death_move_timer_timeout():
	global_position = respawn_location
	free_movement()
