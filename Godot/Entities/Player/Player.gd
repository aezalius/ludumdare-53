extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@onready var interact_area = $InteractArea

@onready var package_sprite = $PackageSprite
@onready var package_scene = preload("res://Entities/Interactables/Package/droppedpackage.tscn")

const SPEED = 150.0
var movement_enabled = true

# Rolling
const ROLL_ACCEL_MULT = 3.0
var is_rolling = false
var can_roll = true
@onready var roll_timer: Timer = $RollTimer
@onready var roll_cooldown: Timer = $RollCooldown

var holding_package = false

func _ready():
	QuestHandler.stop_movement.connect(stop_movement)
	QuestHandler.free_movement.connect(free_movement)
	roll_timer.set_wait_time(0.3)
	roll_timer.connect("timeout", func(): is_rolling = false; free_movement())
	roll_cooldown.set_wait_time(0.4)
	roll_cooldown.connect("timeout", func(): can_roll = true)

func stop_movement():
	movement_enabled = false

func free_movement():
	movement_enabled = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
	if Input.is_action_just_pressed("interact"):
		for body in interact_area.get_overlapping_bodies():
			if body.is_in_group("questgiver"):
				body.interact(package_sprite.visible)
				if package_sprite.visible:
					package_sprite.hide()
		if not package_sprite.visible:
			for body in interact_area.get_overlapping_bodies():
				if body.is_in_group("package"):
					package_sprite.show()
					body.queue_free()
		else:
			package_sprite.hide()
			var package_instance: RigidBody2D = package_scene.instantiate()
			package_instance.global_position = package_sprite.global_position
			get_tree().root.add_child(package_instance)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left","right","up", "down");
	var new_velocity = direction * SPEED
	if movement_enabled:
		if Input.is_action_just_pressed("roll") and can_roll:
			is_rolling = true
			stop_movement()
			can_roll = false
			roll_timer.start()
			roll_cooldown.start() # apparently cannot be called in a function called elsewhere, huh
		
		if is_rolling:
			new_velocity *= ROLL_ACCEL_MULT
		
		if new_velocity != Vector2.ZERO:
			anim_player.play("Walking")
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		else:
			anim_player.play("Standing")
		
		velocity = new_velocity
		
	elif is_rolling:
		if new_velocity != Vector2.ZERO:
			new_velocity *= ROLL_ACCEL_MULT
			velocity = velocity.slerp(new_velocity, 0.5)
	else:
		velocity = Vector2.ZERO

	move_and_slide()

# player drops package if he is hit, player can take 1 hit if he isnt holding a package
func damage():
	if not holding_package:
		print("Player has died!")
	else:
		pass # drop package

