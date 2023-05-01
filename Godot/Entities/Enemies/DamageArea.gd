extends Area2D

var enabled = false
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if enabled:
		player.damage()



func _on_body_entered(body):
	player = body
	enabled = true


func _on_body_exited(_body):
	player = null
	enabled = false
