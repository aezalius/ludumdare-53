extends RigidBody2D
class_name BaseEnemy

# BEING WORKED ON DONT PEEK (definitely not scuffed rn)

##
# A few states the AI could be in
enum AIState {ATTACK, RETURN, HOLD}

##
# Inspector stuffs
@export var disengage_distance = 225 # just about off screen
@export var retreat_distance = 600
@export var aggro_range = 200
@export var return_time = 3.0
@export var range_limit_aggression_timer = 3.0

@export var range_buffer = 10.0

@export var move_speed = 60

##
# onreadys
@onready var sprite: Sprite2D = $Sprite2D # the sprite
@onready var return_timer: Timer = $ReturnTimer
@onready var aggro_area: Area2D = $AggroRange

# The home of this entity, will return to it if it is in the RETURN ai_state
var home_location: Vector2

# Current state of this enemy
var ai_state: AIState = AIState.HOLD # default to a waiting state

# Reference to the player, probably would be best to store this globally instead
var player: CharacterBody2D

#
# Called when the node enters the scene tree for the first time.
func _ready():
	print("spawning in!")
	base_enemy_setup()
	
func base_enemy_setup():
	player = get_tree().get_nodes_in_group("Player")[0]
	return_timer.timeout.connect(query_return_swap)
	$AggroRange/CollisionShape2D.shape.radius = aggro_range
	aggro_area.body_entered.connect(set_attack_state)
	re_home()

#
# Sets the new home location, or the place the enemy goes back to if we go out of its range.
func re_home(new_home: Vector2 = global_position):
	home_location = new_home

#
# 
func query_return_swap():
	if global_position.distance_to(player.global_position) >= aggro_range + range_buffer:
		set_return_state()
	else:
		set_attack_state()
		

func set_return_state():
	ai_state = AIState.RETURN

func set_attack_state(_body: Node2D = null):
	ai_state = AIState.ATTACK

func set_hold_state():
	ai_state = AIState.HOLD

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var player_distance = global_position.distance_to(player.global_position)
	
	
	if ai_state == AIState.HOLD: # Handled by an area2D
		pass
		
	elif ai_state == AIState.ATTACK:
		if global_position.distance_to(home_location) > retreat_distance:
			set_return_state()
			return_timer.start(range_limit_aggression_timer)
		
		if player_distance >= aggro_range + range_buffer:
			ai_state = AIState.HOLD
			return_timer.start(return_time)
		
		# Keep the player at a certain distance for casting spells.
		var velocity = global_position.direction_to(player.global_position)
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
		move_and_collide(velocity * move_speed * delta)
	else: # return state
		var velocity = global_position.direction_to(home_location)
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
		move_and_collide(velocity * move_speed * delta)
