extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = GameHandler.player_instance.global_position
	$AnimatedSprite2D.set_frame_and_progress(0, 0.0)
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_damage_timer_timeout():
	for body in $DamageZone.get_overlapping_bodies():
		body.damage()

func _on_destroy_timer_timeout():
	self.queue_free()


