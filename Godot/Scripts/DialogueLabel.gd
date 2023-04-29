extends Label

func _ready():
	QuestHandler.next_dialogue_line_s.connect(set_line)
	QuestHandler.clear_dialogue.connect(clear_line)
	
func set_line(line: String):
	text = line

func clear_line():
	text = ""
