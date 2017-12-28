extends Node2D

var Level
var AtMenu = false


func _ready():
	var content = LoadContent("user://save.dat")
	if(content == ""):
		content = "1"
	Level = load("res://level.tscn").instance()
	Level.GeneratingString = content
	add_child(Level)
	set_process_input(true)
	get_node("New Game(1 set)").hide()
	get_node("New Game(2 sets)").hide()
	get_node("Exit").hide()



func _input(event):
	if(event.type == InputEvent.KEY):
		if(event.scancode == KEY_ESCAPE):
			if(not AtMenu):
				Level.hide()
				Level.set_process(false)
				Level.set_process_input(false)
				get_node("New Game(1 set)").show()
				get_node("New Game(2 sets)").show()
				get_node("Music Button").show()
				get_node("Color Scheme").show()
				get_node("Exit").show()
				AtMenu = true
			else:
				get_node("New Game(1 set)").hide()
				get_node("New Game(2 sets)").hide()
				get_node("Music Button").hide()
				get_node("Color Scheme").hide()
				get_node("Exit").hide()
				Level.show()
				Level.set_process(true)
				Level.set_process_input(true)
				AtMenu = false
			get_node("Timer").set_wait_time(0.2)
			get_node("Timer").start()
			set_process_input(false)
		
		if(event.scancode == KEY_C):
			Level.ColorScheme = (Level.ColorScheme % 3) + 1
			for i in range(Level.Rooms.size()):
				if(Level.ColorScheme == 1):
					Level.Rooms[i].RoomColor = Color(Level.ColorsOne[i])
				elif(Level.ColorScheme == 2):
					Level.Rooms[i].RoomColor = Color(Level.ColorsTwo[i])
				elif(Level.ColorScheme == 3):
					Level.Rooms[i].RoomColor = Color(Level.ColorsThree[i])
			Level.Rooms[Level.CurrentRoom].update()
			for roomblocks in Level.Rooms[Level.CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.update()
			
			get_node("Color Scheme").set_text("Color Scheme " + str(Level.ColorScheme))
			get_node("Timer").set_wait_time(0.2)
			get_node("Timer").start()
			set_process_input(false)
	
	if(AtMenu):
		if(get_node("New Game(1 set)").is_pressed()):
			var Scheme = Level.ColorScheme
			var Music = Level.Music
			remove_child(Level)
			Level = load("res://level.tscn").instance()
			Level.GeneratingString = "1"
			Level.ColorScheme = Scheme
			Level.Music = Music
			add_child(Level)
			get_node("New Game(1 set)").hide()
			get_node("New Game(2 sets)").hide()
			get_node("Music Button").hide()
			get_node("Color Scheme").hide()
			get_node("Exit").hide()
			AtMenu = false
		
		if(get_node("New Game(2 sets)").is_pressed()):
			var Scheme = Level.ColorScheme
			var Music = Level.Music
			remove_child(Level)
			Level = load("res://level.tscn").instance()
			Level.GeneratingString = "2"
			Level.ColorScheme = Scheme
			Level.Music = Music
			add_child(Level)
			get_node("New Game(1 set)").hide()
			get_node("New Game(2 sets)").hide()
			get_node("Music Button").hide()
			get_node("Color Scheme").hide()
			get_node("Exit").hide()
			AtMenu = false
		
		if(get_node("Color Scheme").is_pressed()):
			Level.ColorScheme = (Level.ColorScheme % 3) + 1
			get_node("Color Scheme").set_text("Color Scheme " + str(Level.ColorScheme))
			for i in range(Level.Rooms.size()):
				if(Level.ColorScheme == 1):
					Level.Rooms[i].RoomColor = Color(Level.ColorsOne[i])
				elif(Level.ColorScheme == 2):
					Level.Rooms[i].RoomColor = Color(Level.ColorsTwo[i])
				elif(Level.ColorScheme == 3):
					Level.Rooms[i].RoomColor = Color(Level.ColorsThree[i])
			
			Level.Rooms[Level.CurrentRoom].update()
			for roomblocks in Level.Rooms[Level.CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.update()
		
		if(get_node("Music Button").is_pressed()):
			Level.Music = 1 - Level.Music
			if(Level.Music == 0):
				get_node("music").stop()
				get_node("Music Button").set_text("Music: off")
			else:
				get_node("music").play()
				get_node("Music Button").set_text("Music: on")
			
		
		if(get_node("Exit").is_pressed()):
			Level.SaveGame("user://save.dat")
			get_tree().quit()


func SaveContent(content, path):
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(content)
	file.close()

func LoadContent(path):
	var file = File.new()
	var content = ""
	if(file.file_exists(path)):
		file.open(path, file.READ)
		content = file.get_as_text()
	file.close()
	return content

func _on_Timer_timeout():
	set_process_input(true)
