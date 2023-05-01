extends Node2D
class_name DeliveryClient

##
# Inspector stuffs
@export var client_name: String = "Bill"
@export var thanks_speech_options: Array[String] = ["Thank you."]
@export var misc_speech_options: Array[String] = ["What?"]


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
	if DialogueHandler.is_in_dialogue():
		DialogueHandler.next_dialogue_line()
	
	if QuestHandler.active_quest != null and QuestHandler.active_quest.quest_complete:
		var selected_thanks: String = thanks_speech_options[randi_range(0,thanks_speech_options.size() - 1)]
		#DialogueHandler.emit_signal("next_dialogue_line_s", selected_thanks) # TODO: expand this
		DialogueHandler.current_speech = [selected_thanks]
		DialogueHandler.next_dialogue_line()
	else:
		var selected_misc: String = misc_speech_options[randi_range(0,misc_speech_options.size() - 1)]
		#DialogueHandler.emit_signal("next_dialogue_line_s", selected_misc) # TODO: expand this
		DialogueHandler.current_speech = [selected_misc]
		DialogueHandler.next_dialogue_line()