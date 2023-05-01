extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = GameHandler.player_instance.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_damage_timer_timeout():
	# TODO: damage player
	pass

func _on_destroy_timer_timeout():
	self.queue_free()


