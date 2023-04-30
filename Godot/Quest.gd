extends Resource
class_name Quest

##
# Inspector stuffs
@export var quest_name: String = "Unnamed Quest"
@export var client: DeliveryClient
@export var encounters: Array[QuestEncounter] = [] 

##
# Index of the current encounter objective (for the objective arrow)
var current_encounter_idx: int = 0

##
# Dialogue variables, to be moved later
var spawn_encounter_after_dialogue = false
var free_encounter_with_dialogue = false

#
# runtime variables
var quest_complete: bool = false # TEST VARIABLE

#
# Get the locaiton of the next objective
func get_target_location() -> Vector2:
	if current_encounter_idx < encounters.size() - 1:
		return encounters[current_encounter_idx].encounter_location
	else:
		return client.client_node.global_position
