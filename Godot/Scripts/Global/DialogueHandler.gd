extends Node

signal next_dialogue_line_s(line: String)
signal clear_dialogue()

var current_speech: Array
var speech_index = 0

func is_in_dialogue() -> bool:
	return current_speech.size() > 0 and speech_index < current_speech.size()

#
# Advance the dialogue, TODO: move this to a dialogue handler
func next_dialogue_line() -> void:
	if current_speech.size() > 0 and speech_index < current_speech.size():
		QuestHandler.emit_signal("stop_movement")
		emit_signal("next_dialogue_line_s", current_speech[speech_index])
		GameHandler.player_instance.dialogue_audio_player.play()
		speech_index += 1
		#if free_encounter_with_dialogue:
		#	QuestHandler.emit_signal("remove_encounter")
		#	free_encounter_with_dialogue = false
	else:
		QuestHandler.emit_signal("free_movement")
		emit_signal("clear_dialogue")
		current_speech = []
		speech_index = 0
		#if spawn_encounter_after_dialogue:
		#	QuestHandler.emit_signal("spawn_encounter")
		#	spawn_encounter_after_dialogue = false
