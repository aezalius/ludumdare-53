extends Node2D
class_name DeliveryClient

##
# Inspector stuffs
@export var client_name: String = "Bill"
@export var thanks_speech_options: Array[String] = ["Thank you."]
@export var misc_speech_options: Array[String] = ["What?"]

##
# Test variables
var interacting: bool = false

#
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#
# Called when the player presses the interact key when overlapping
func interact():
	if not interacting:
		interacting = true
		QuestHandler.emit_signal("stop_movement")
		if QuestHandler.active_quest != null and QuestHandler.active_quest.quest_complete:
			var selected_thanks: String = thanks_speech_options[randi_range(0,thanks_speech_options.size() - 1)]
			QuestHandler.emit_signal("next_dialogue_line_s", selected_thanks) # TODO: expand this
		else:
			var selected_misc: String = misc_speech_options[randi_range(0,misc_speech_options.size() - 1)]
			QuestHandler.emit_signal("next_dialogue_line_s", selected_misc) # TODO: expand this
	else:
		interacting = false
		QuestHandler.emit_signal("free_movement")
		QuestHandler.emit_signal("clear_dialogue")
