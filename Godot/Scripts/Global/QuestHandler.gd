extends Node

##
# Misc stuff to be moved later
signal next_dialogue_line_s(line: String)
signal clear_dialogue()
signal spawn_encounter()
signal remove_encounter()

##
# Player movement controls (weird spot, to be moved later)
signal stop_movement()
signal free_movement()

##
# the active level (set by the levels _ready function when it is loaded_
var active_level: Level

##
# The difficulty, later will be the numer of encounters and gathered items to be added into each quest.
var difficulty = 1

##
# The current quest
var active_quest: Quest

#
# Generate a new quest, will call a LOT of other places
func generate_new_quest() -> void:
	var new_quest = Quest.new()
	new_quest.encounters.push_back(active_level.pull_and_reserve_encounter())
	new_quest.client = active_level.get_delivery_client()
	active_quest = new_quest


