extends Label

#
# Called when the node enters the scene tree
func _ready():
	QuestHandler.next_dialogue_line_s.connect(set_line)
	QuestHandler.clear_dialogue.connect(clear_line)

#
# Sets the text
func set_line(line: String):
	text = line

#
# Clears the text
func clear_line():
	text = ""
