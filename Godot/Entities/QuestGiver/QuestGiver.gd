extends StaticBody2D

##
# Dialogue options list
var greeting = ["'Sup, Dave", "Yo, got a new one in", "Howdy"]
var request = [" needs a ", " wants another ", " is craving a ", " is wanting one ", " requested a ", " put in an order for a "]
var ending = ["Stay safe!", "Have fun", "Don't get eaten", "Good luck", "That's it"]
var thanks = ["Good work out there", "Good job, Dave", "Nice work!", "Review just came in, good stuff!"]
var quest_complete_options = ["Review just came in, very nice!", "Good work!", "Nice job, onto the next one, then"]

##
# Current dialogue holding, to be moved to a dialogue handler global
var current_speech: Array
var speech_index = 0

#
# Called when the player presses the interact key when overlapping
func interact(holding: bool = false):
	# If we are in dialogue, progress it (move to dialogue handler)
	if DialogueHandler.is_in_dialogue():
		DialogueHandler.next_dialogue_line()
	else:
		# If there is no quest, ...
		if QuestHandler.active_quest == null:
			# If we're just starting this dialogue, generate a quest and start the speech
			if DialogueHandler.current_speech.size() == 0:
				QuestHandler.generate_new_quest()
				generate_request_speech()
			DialogueHandler.next_dialogue_line()
		elif QuestHandler.active_quest.quest_turned_in:
			generate_quest_complete_speech()
			DialogueHandler.next_dialogue_line()
			QuestHandler.clear_quest()
		else:
			# TODO: maybe allow for scrapping a quest
			# if the player is holding an item
			if holding:
				DialogueHandler.current_speech = ["Woah, woah, woah I don't want that!", "Get that to the client!"]
			else:
				# small talk
				generate_misc_speech()
			DialogueHandler.next_dialogue_line()

#
# Generate the speech for a quest request, add in needed stuff from the active quest after generation
func generate_request_speech() -> void: # TODO: add some failsafes in case no quest is loaded and this is called
	var selected_greeting = greeting[randi_range(0,greeting.size() - 1)]
	var selected_request = QuestHandler.active_quest.client.client_name + " " + request[randi_range(0,request.size() - 1)] + " THING"
	var selected_ending = ending[randi_range(0,ending.size() - 1)]
	DialogueHandler.current_speech = [selected_greeting, selected_request, selected_ending]
	#spawn_encounter_after_dialogue = true

#
# Generate a dialogue to thank the player
func generate_thanks_speech() -> void:
	var selected_greeting = greeting[randi_range(0,greeting.size() - 1)]
	var selected_thanks = thanks[randi_range(0,thanks.size() - 1)]
	DialogueHandler.current_speech = [selected_greeting, selected_thanks]
	#free_encounter_with_dialogue = true

#
# Generate speech for if the player brings him the item
func generate_misc_speech() -> void:
	DialogueHandler.current_speech = ["You're on the clock, dude...", "Get back out there!"]

func generate_quest_complete_speech() -> void:
	var selected_speech = quest_complete_options[randi_range(0, quest_complete_options.size() - 1)]
	DialogueHandler.current_speech = [selected_speech]
