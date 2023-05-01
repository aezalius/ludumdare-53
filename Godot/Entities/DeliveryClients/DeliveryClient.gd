extends Node2D
class_name DeliveryClient

##
# Inspector stuffs
@export var client_name: String = "Bill"
@export var thanks_speech_options: Array[String] = ["Thank you."]
@export var misc_speech_options: Array[String] = ["What?"]
@export var annoyed_speech_options: Array[String] = ["Get me my stuff, man...", "Uhh... shouldn't you have my stuff with you?"]
@export var already_completed_options: Array[String] = ["Thanks again!"]


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
	
	if QuestHandler.active_quest != null and QuestHandler.active_quest.client == self:
		if QuestHandler.active_quest.quest_complete:
			var selected_thanks: String = thanks_speech_options[randi_range(0,thanks_speech_options.size() - 1)]
			DialogueHandler.current_speech = [selected_thanks]
			DialogueHandler.next_dialogue_line()
			QuestHandler.active_quest.quest_turned_in = true
		elif QuestHandler.active_quest.quest_turned_in:
			var selected_thanks2: String = already_completed_options[randi_range(0,already_completed_options.size() - 1)]
			DialogueHandler.current_speech = [selected_thanks2]
			DialogueHandler.next_dialogue_line()
		else:
			var selected_annoyed: String = annoyed_speech_options[randi_range(0,annoyed_speech_options.size() - 1)]
			DialogueHandler.current_speech = [selected_annoyed]
			DialogueHandler.next_dialogue_line()
	else:
		var selected_misc: String = annoyed_speech_options[randi_range(0,annoyed_speech_options.size() - 1)]
		#DialogueHandler.emit_signal("next_dialogue_line_s", selected_misc) # TODO: expand this
		DialogueHandler.current_speech = [selected_misc]
		DialogueHandler.next_dialogue_line()
