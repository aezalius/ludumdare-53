extends BaseEnemy
class_name CasterEnemy

# BEING WORKED ON DONT PEEK (definitely not scuffed rn)

##
# A few states the AI could be in
#enum AIState {ATTACK, RETURN, HOLD}

##
# Inspector stuffs
@export var spell_cast_delay: float = 0.4
@export var spell_burst_cooldown: float = 2.0
@export var spell_burst_cast_amount: int = 6
@export var spell_burst_cooldown_random_range: float = 0.25

@export var player_ideal_distance_min: float = 100
@export var player_ideal_distance_max: float = 200

var ideal_player_distance: float


##
# onreadys
@onready var spell_scene: PackedScene = preload("res://Entities/Enemies/CasterEnemy/CasterCircle.tscn") # The scene to be spawned when a cast happens
@onready var spell_cast_timer: Timer = $SpellCastTimer
@onready var spell_burst_cooldown_timer: Timer = $SpellBurstCooldownTimer

##
# Spell variables
var spells_cast_in_burst = 0


#
# Called when the node enters the scene tree for the first time.
func _ready():
	base_enemy_setup()
	
	#ideal_player_distance = aggro_range / 2
	player_ideal_distance_min = aggro_range / 2.0
	player_ideal_distance_max = (aggro_range / 3.0) * 2.0
	
	spell_cast_timer.wait_time = spell_cast_delay
	spell_cast_timer.timeout.connect(spell_cooldown_timeout)
	
	spell_burst_cooldown_timer.wait_time = spell_burst_cooldown
	spell_burst_cooldown_timer.timeout.connect(spell_burst_cooldown_timeout)

#
# If the spell cooldown ends, we check to see if we are in the attack state, then instance another spell
func spell_cooldown_timeout():
	if ai_state == AIState.ATTACK and spell_burst_cooldown_timer.is_stopped():
		spells_cast_in_burst += 1
		var new_spell = spell_scene.instantiate()
		get_tree().root.add_child(new_spell) # Spell should contain the spawning logic
		if spells_cast_in_burst < spell_burst_cast_amount:
			if spell_cast_timer.is_stopped():
				spell_cast_timer.start(spell_cast_delay)
		else:
			spells_cast_in_burst = 0
			spell_burst_cooldown_timer.start(randf_range(spell_burst_cooldown - spell_burst_cooldown_random_range, spell_burst_cooldown + spell_burst_cooldown_random_range))
	else:
		spell_cast_timer.stop()

#
# Loop back in once the burst cooldown has ended
func spell_burst_cooldown_timeout():
	pass#print("going!")

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ai_state == AIState.HOLD: # Handled by an area2D
		pass
		
	elif ai_state == AIState.ATTACK:
		if global_position.distance_to(home_location) > retreat_distance:
			set_return_state()
			return_timer.start(range_limit_aggression_timer)
		var player_distance = global_position.distance_to(player.global_position)
		if player_distance >= aggro_range + range_buffer:
			ai_state = AIState.HOLD
			return_timer.start(return_time)
		
		if spell_cast_timer.is_stopped():
			spell_cast_timer.start(spell_cast_delay)
		
		
		# Keep the player at a certain distance for casting spells.
		var velocity: Vector2 = Vector2.ZERO
		if player_distance < player_ideal_distance_min:
			velocity = Vector2.ZERO - global_position.direction_to(player.global_position)
		elif player_distance > player_ideal_distance_max:
			velocity = global_position.direction_to(player.global_position)
		
		
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
		move_and_collide(velocity * move_speed * delta)
	else: # return state
		var home_distance = global_position.distance_to(home_location)
		if home_distance < 5:
			set_hold_state()
			return
		var velocity = global_position.direction_to(home_location)
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
		move_and_collide(velocity * move_speed * delta)


func _on_spell_cast_timer_timeout():
	pass#spell_cooldown_timeout()
