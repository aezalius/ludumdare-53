extends Resource
class_name QuestEncounter

##
# Inspector stuffs
@export var encounter_name: String = "TestEncounter"
@export var package_name: String = "Toad Heart"
@export var encounter_location: Vector2 = Vector2.ZERO
@export var encounter_scene: PackedScene

##
# Storage for the spawned encounter nodes
var spawned_scene: Node

#
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#
# Create an instance of the encounter, store and return it
func spawn() -> Node:
	print("Spawning encounter 2")
	spawned_scene = encounter_scene.instantiate()
	spawned_scene.global_position = encounter_location
	return spawned_scene

#
# Activate the encounter if it is of that type
func activate():
	if spawned_scene.is_in_group("ActivatableEncounter"):
		spawned_scene.activate()

func clear():
	spawned_scene.queue_free()
