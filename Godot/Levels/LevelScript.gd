extends Node2D

@export_subgroup("Important locations")
@export var encounter_table: Array[PackedScene]

var active_encounter: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	QuestHandler.spawn_encounter.connect(spawn_encounter)
	QuestHandler.remove_encounter.connect(remove_encounter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_encounter():
	var encounter: Node2D = encounter_table[randi_range(0,encounter_table.size() - 1)].instantiate()
	#encounter.global_position = encounter.get_spawn_location()#encounter_spawn_locations[randi_range(0,encounter_spawn_locations.size() - 1)] # godot wont let me do things nicely, so hacky it is!
	get_tree().root.add_child(encounter)
	active_encounter = encounter

func remove_encounter():
	active_encounter.queue_free()
