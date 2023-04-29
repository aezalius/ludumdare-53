extends CharacterBody2D


const SPEED = 300.0
var movement_enabled = true

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left","right","up", "down");
	if movement_enabled:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
