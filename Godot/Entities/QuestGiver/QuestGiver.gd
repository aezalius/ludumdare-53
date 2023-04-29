extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(holding: bool = false):
	if holding == false:
		#TODO: actually generate a quest and spawn the needed things in the world
		if QuestHandler.current_speech.size() == 0:
			QuestHandler.generate_request_speech()
		QuestHandler.next_dialogue_line()
	else:
		QuestHandler.generate_thanks_speech()
		QuestHandler.next_dialogue_line()
