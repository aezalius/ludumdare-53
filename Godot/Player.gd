extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

@onready var interact_area = $InteractArea

@onready var package_sprite = $PackageSprite
@onready var package_scene = preload("res://droppedpackage.tscn")

const SPEED = 150.0
var movement_enabled = true

var holding_package = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
	if Input.is_action_just_pressed("roll"):
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
	if movement_enabled:
		velocity = direction * SPEED
		if velocity != Vector2.ZERO:
			anim_player.play("Walking")
			if direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		else:
			anim_player.play("Standing")
	else:
		velocity = Vector2.ZERO

	move_and_slide()

# player drops package if he is hit, player can take 1 hit if he isnt holding a package
func damage():
	if not holding_package:
		print("Player has died!")
	else:
		pass # drop package

