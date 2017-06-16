extends Node2D

var Level


func _ready():
	
	Level = load("res://level.tscn").instance()
	Level.GeneratingString = loadcontent()
	print(Level.GeneratingString)
	add_child(Level)
	set_process_input(true)
	


func _input(event):
	if(event.type == InputEvent.KEY):
		if(event.scancode == KEY_R):
			remove_child(Level)
			savecontent("")
			Level = load("res://level.tscn").instance()
			Level.GeneratingString = ""
			add_child(Level)
		if(event.scancode == KEY_P):
			remove_child(Level)
			Level = load("res://level.tscn").instance()
			Level.GeneratingString = loadcontent()
			add_child(Level)



func savecontent(content):
	var file = File.new()
	file.open("user://save_game.dat", file.WRITE)
	file.store_string(content)
	file.close()

func loadcontent():
	var file = File.new()
	var content = ""
	if(file.file_exists("user://save_game.dat")):
		file.open("user://save_game.dat", file.READ)
		content = file.get_as_text()
	file.close()
	return content