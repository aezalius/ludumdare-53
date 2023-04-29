extends RigidBody2D

# super basic enemy that moves towards the player if they get close and stops if they move too far away.

const SPEED = 30

const DISENGAGE_DISTANCE = 225 # just about off screen

var aggro = false
var enraged = false
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if aggro:
		var velocity = global_position.direction_to(player.global_position)
		move_and_collide(velocity * SPEED * delta)
		if not enraged:
			if global_position.distance_to(player.global_position) > DISENGAGE_DISTANCE:
				aggro = false
	else:
		pass # have them meander around a bit, makes their location less predictable.


func _on_aggro_range_body_entered(_body):
	aggro = true
