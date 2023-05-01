extends Node
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
var quest_complete: bool = false
var quest_turned_in: bool = false 

#
# Cleanly delete self
func clear() -> void:
	for encounter in encounters:
		encounter.clear()
	queue_free()

#
# Get the locaiton of the next objective
func get_target_location() -> Vector2:
	if current_encounter_idx < encounters.size():
		return encounters[current_encounter_idx].encounter_location
	else:
		return client.global_position

#
# Complete the current encounter
func complete_current_encounter():
	current_encounter_idx += 1
	if current_encounter_idx >= encounters.size():
		print("All encounters complete")
		quest_complete = true
	else:
		print("Quest encounter complete")

#
# Spawn next encounter
func spawn_next_encounter(level: Level):
	print("Spawning encounter")
	level.get_tree().root.add_child(encounters[current_encounter_idx].spawn())
	encounters[current_encounter_idx].activate()
