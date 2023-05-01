extends Node2D
class_name Level

@export_subgroup("Important locations")
#@export var encounter_table: Array[PackedScene]
@export var encounters: Array[QuestEncounter]
@export var clients: Array[DeliveryClient]  # BUG: not being assigned in the inspector
@onready var clientsNodeParent: Node = $Clients # Workaround, iterate over children
var available_encounters: Array[QuestEncounter]

#
# Called when the node enters the scene tree for the first time.
func _ready():
	# Godot bug workaround, cannot assign clients array in inspector
	clients.clear()
	for client_node in clientsNodeParent.get_children():
		clients.push_back(client_node)
	
	# Set this as the active level.
	QuestHandler.active_level = self
	# Reset the encounter list
	reset_available_encounters()
	
	# Connect to the needed encounter spawning stuff
	#QuestHandler.spawn_encounter.connect(spawn_encounter)
	#QuestHandler.remove_encounter.connect(remove_encounter)

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#
# Reset the list of available encounters
func reset_available_encounters() -> void:
	available_encounters.clear()
	available_encounters = encounters.duplicate()
	
#
# Select a random encounter from those not already reserved, return it.
func pull_and_reserve_encounter() -> QuestEncounter:
	if available_encounters != null:
		var selected_encounter = available_encounters[randi_range(0,available_encounters.size() - 1)]
		available_encounters.erase(selected_encounter)
		return selected_encounter
	else:
		return null

#
# Get a random client from the list
func get_delivery_client() -> DeliveryClient:
	#print("Getting client from " + str(clients.size()) + " available")
	return clients[randi_range(0, clients.size() - 1)]

#
# UNUSED: spawn an encounter into the level
func spawn_encounter():
	#var encounter: Node2D = encounter_table[randi_range(0,encounter_table.size() - 1)].instantiate()
	#encounter.global_position = encounter.get_spawn_location()#encounter_spawn_locations[randi_range(0,encounter_spawn_locations.size() - 1)] # godot wont let me do things nicely, so hacky it is!
	#get_tree().root.add_child(encounter)
	#active_encounter = encounter
	pass

#
# UNUSED: Remove the encounter from the level
func remove_encounter():
	#if active_encounter != null:
	#	active_encounter.queue_free()
	pass
