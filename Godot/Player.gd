extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

const SPEED = 150.0
var movement_enabled = true

var holding_package = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()

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
