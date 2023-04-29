extends Node

signal next_dialogue_line_s(line: String)
signal clear_dialogue()
signal spawn_encounter()
signal remove_encounter()

# Effectively stops player input, with things for future.
signal stop_movement()
signal free_movement()

var greeting = ["Greetings...", "Hello, young courier...", "..."]
var request = ["I require one ", "My master requests a ", "I am in need of a ", "I request one ", "I need a ", "Fetch me a "]
var ending = ["Return quickly...", "...", "Good luck...", "Good luck", "That is all...", "See you soon"]
var thanks = ["Thank you"]

var current_speech: Array
var speech_index = 0
var spawn_encounter_after_dialogue = false
var free_encounter_with_dialogue = false

func generate_request_speech() -> void:
	var selected_greeting = greeting[randi_range(0,greeting.size() - 1)]
	var selected_request = request[randi_range(0,request.size() - 1)]
	var selected_ending = ending[randi_range(0,ending.size() - 1)]
	current_speech = [selected_greeting, selected_request, selected_ending]
	spawn_encounter_after_dialogue = true

func generate_thanks_speech() -> void:
	var selected_greeting = greeting[randi_range(0,greeting.size() - 1)]
	var selected_thanks = thanks[randi_range(0,thanks.size() - 1)]
	current_speech = [selected_greeting, selected_thanks]
	free_encounter_with_dialogue = true

func next_dialogue_line():
	if current_speech.size() > 0 and speech_index < current_speech.size():
		emit_signal("stop_movement")
		emit_signal("next_dialogue_line_s", current_speech[speech_index])
		speech_index += 1
		if free_encounter_with_dialogue:
			emit_signal("remove_encounter")
			free_encounter_with_dialogue = false
	else:
		emit_signal("free_movement")
		emit_signal("clear_dialogue")
		current_speech = []
		speech_index = 0
		if spawn_encounter_after_dialogue:
			emit_signal("spawn_encounter")
			spawn_encounter_after_dialogue = false
