extends Node2D

var Rooms = []
var MovedNorth = false
var MovedWest = false
var MovedSouth = false
var MovedEast = false
var RoomSize = Vector2(800,800)
var DummyRoom = preload("res://room.tscn").instance()
export var CurrentRoom = 1
onready var tween = get_node("Tween")

func _ready():
	RoomSize.x = get_viewport_rect().size.y
	RoomSize.y = RoomSize.x
	#get_node("camera").set_pos(RoomSize*0.5)
	var temp = 1
	if(temp == 0):
		CurrentRoom = 2
		var room = load("res://room.tscn")
		for i in range(16):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color(0.2,0.5,0.3) #Color(0.5,(i+16)/32.0,cos(i))
			Rooms[i].Type = i
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "1,1,1/2,4,1/3,1,3/4,3,4/5,3,3/"
		string += "6,3,1/7,2,1/8,4,4/9,1,4/10,4,2/"
		string += "11,2,2/12,3,2/13,2,4/14,4,3/15,2,3"
		Rooms[10].InitBlocks(string)
		Rooms[CurrentRoom].show()
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 1):
		CurrentRoom = 0
		var array = [8,15]
		var room = load("res://room.tscn")
		for i in range(array.size()):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color(0.2,0.5,0.3) #Color(0.5,(i+16)/32.0,cos(i))
			Rooms[i].Type = array[i]
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		
		var string = "0,2,4/1,0,0/1,2,0/1,2,3"
		Rooms[1].InitBlocks(string)
		Rooms[CurrentRoom].show()
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 2):
		CurrentRoom = 2
		var room = load("res://room.tscn")
		for i in range(16):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color(0.2,0.5,0.3) #Color(0.5,(i+16)/32.0,cos(i))
			Rooms[i].Type = i
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "1,1,1/2,4,1/3,1,3/4,3,4/5,3,3/"
		string += "6,3,1/7,2,1/8,4,4/9,1,4/10,4,2/"
		string += "11,2,2/12,3,2/13,2,4/14,4,3/15,2,3"
		Rooms[10].InitBlocks(string)
		string = "1,0,0/2,2,0/3,4,0/"
		string += "4,1,1/5,3,1/6,5,1/"
		string += "7,0,2/8,2,2/9,4,2/"
		string += "10,1,3/11,3,3/12,5,3/"
		string += "13,0,4/14,2,4/15,4,4"
		Rooms[5].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 3):
		CurrentRoom = 0
		var room = load("res://room.tscn")
		for i in range(5):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color((sin(2.0*i+1.0)+1.0)*0.5,i/5.0,(cos(i)+1.0)*0.5)
			Rooms[i].Type = 15
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "0,3,2/1,2,3/2,2,1/3,1,2/4,2,2"
		Rooms[1].InitBlocks(string)
		string = "0,2,3/1,2,1/2,1,2/3,2,2"
		Rooms[2].InitBlocks(string)
		string = "0,2,1/1,1,2/2,2,2"
		Rooms[3].InitBlocks(string)
		string = "0,2,2/1,3,2"
		Rooms[4].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 4):
		#NOTE(ian): This is pretty cool!!!!!!!
		CurrentRoom = 0
		var room = load("res://room.tscn")
		var types = [14,13,11,7]
		for i in range(4):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color((sin(2.0*i+1.0)+1.0)*0.5,i/5.0,(cos(i)+1.0)*0.5)
			Rooms[i].Type = types[i]
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "0,0,0/0,2,0/1,1,1/1,3,1/"
		string += "2,0,2/2,2,2/3,1,3/3,3,3"
		Rooms[0].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 5):
		CurrentRoom = 1
		var room = load("res://room.tscn")
		var types = []
		for i in range(32):
			Rooms.append(room.instance())
			if(i < 16):
				Rooms[i].RoomColor = Color(0.1,0.2,0.4)
			else:
				Rooms[i].RoomColor = Color(0.4,0.1,0.2)
			Rooms[i].Type = i%16
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "1,0,0/2,2,0/3,4,0/4,1,1/5,3,1/6,5,1/"
		string += "7,0,2/8,2,2/9,4,2/10,1,3/11,3,3/12,5,3/"
		string += "13,0,4/14,2,4/15,4,4/19,3,5"
		Rooms[1].InitBlocks(string)
		string = "1,0,0/2,2,0/3,4,0/4,1,1/5,3,1/6,5,1/"
		string += "7,0,2/8,2,2/9,4,2/10,1,3/11,3,3/12,5,3/"
		string += "13,0,4/14,2,4/15,4,4"
		Rooms[5].InitBlocks(string)
		string = "17,0,0/18,2,0/19,4,0/20,1,1/21,3,1/22,5,1/"
		string += "23,0,2/24,2,2/25,4,2/26,1,3/27,3,3/28,5,3/"
		string += "29,0,4/30,2,4/31,4,4"
		Rooms[19].InitBlocks(string)
		string = "17,0,0/18,2,0/19,4,0/20,1,1/21,3,1/22,5,1/"
		string += "23,0,2/24,2,2/25,4,2/26,1,3/27,3,3/28,5,3/"
		string += "29,0,4/30,2,4/31,4,4"
		Rooms[30].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
		CurrentRoom = 4
		var room = load("res://room.tscn")
		var types = [7,11,13,14,15]
		for i in range(types.size()):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color((cos(i)+1.0)*0.5,i/convert(types.size(),TYPE_REAL),0.2)
			Rooms[i].Type = types[i]
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "0,0,0/0,2,0/1,1,1/1,3,1/2,0,2/2,2,2/"
		string += "3,1,3/3,3,3/4,0,4/4,2,4"
		Rooms[4].InitBlocks(string)
		
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 7):
		#NOTE(ian): This is pretty cool!!!!!!
		CurrentRoom = 4
		var room = load("res://room.tscn")
		var types = [3,6,9,12,15]
		for i in range(types.size()):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color((cos(i)+1.0)*0.5,i/convert(types.size(),TYPE_REAL),0.2)
			Rooms[i].Type = types[i]
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "0,0,0/0,2,0/1,1,1/1,3,1/2,0,2/2,2,2/"
		string += "3,1,3/3,3,3/4,0,4/4,2,4"
		Rooms[4].InitBlocks(string)
		
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	elif(temp == 8):
		CurrentRoom = 4
		var room = load("res://room.tscn")
		var types = [3,6,9,12,15,5,10]
		for i in range(types.size()):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color(1,1,1)
			Rooms[i].Type = types[i]
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "0,0,0/0,2,0/1,1,1/1,3,1/2,0,2/2,2,2/"
		string += "3,1,3/3,3,3/4,0,4/4,2,4/5,4,0/5,5,1/6,4,2/6,5,3"
		Rooms[4].InitBlocks(string)
		
		Rooms[CurrentRoom].show()
		
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
	
	DummyRoom.hide()
	add_child(DummyRoom)
	set_process_input(true)


func _draw():
	pass



func _input(event):
	if(event.type == InputEvent.KEY and event.is_pressed()):
		
		if(event.scancode == KEY_ESCAPE):
			get_tree().quit()
		var type = Rooms[CurrentRoom].Type
		if(((type&8)>>3) == 1):
			if(Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North) == 1):
				var room = Rooms[CurrentRoom]
				if(room.NumConnections(Rooms[room.North[0][0]].South) == 1):
					if(event.scancode == KEY_UP):
						Rooms[CurrentRoom].set_process(false)
						if(CurrentRoom != Rooms[CurrentRoom].North[0][0]):
							tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,RoomSize.y),0.5,1,2)
							CurrentRoom = Rooms[CurrentRoom].North[0][0]
							Rooms[CurrentRoom].show()
						else:
							CreateDummyRoom(Rooms[CurrentRoom])
							DummyRoom.set_pos(Vector2(0,0))
							DummyRoom.show()
							tween.interpolate_property(DummyRoom,"transform/pos",DummyRoom.get_pos(),Vector2(0,RoomSize.y),0.5,1,2)
						Rooms[CurrentRoom].set_pos(Vector2(0,-RoomSize.y))
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,0),0.5,1,2)
						MovedNorth = true
						set_process_input(false)
						tween.start()
		
		if(((type&4)>>2) == 1):
			if(Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West) == 1):
				var room = Rooms[CurrentRoom]
				if(room.NumConnections(Rooms[room.West[0][0]].East) == 1):
					if(event.scancode == KEY_LEFT):
						Rooms[CurrentRoom].set_process(false)
						if(CurrentRoom != Rooms[CurrentRoom].West[0][0]):
							tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(RoomSize.x,0),0.5,1,2)
							CurrentRoom = Rooms[CurrentRoom].West[0][0]
							Rooms[CurrentRoom].show()
						else:
							CreateDummyRoom(Rooms[CurrentRoom])
							DummyRoom.set_pos(Vector2(0,0))
							DummyRoom.show()
							tween.interpolate_property(DummyRoom,"transform/pos",DummyRoom.get_pos(),Vector2(RoomSize.x,0),0.5,1,2)
						Rooms[CurrentRoom].set_pos(Vector2(-RoomSize.x,0))
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,0),0.5,1,2)
						MovedWest = true
						set_process_input(false)
						tween.start()
		
		if(((type&2)>>1) == 1):
			if(Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South) == 1):
				var room = Rooms[CurrentRoom]
				if(room.NumConnections(Rooms[room.South[0][0]].North) == 1):
					if(event.scancode == KEY_DOWN):
						Rooms[CurrentRoom].set_process(false)
						if(CurrentRoom != Rooms[CurrentRoom].South[0][0]):
							tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,-RoomSize.y),0.5,1,2)
							CurrentRoom = Rooms[CurrentRoom].South[0][0]
							Rooms[CurrentRoom].show()
						else:
							CreateDummyRoom(Rooms[CurrentRoom])
							DummyRoom.set_pos(Vector2(0,0))
							DummyRoom.show()
							tween.interpolate_property(DummyRoom,"transform/pos",DummyRoom.get_pos(),Vector2(0,-RoomSize.y),0.5,1,2)
						Rooms[CurrentRoom].set_pos(Vector2(0,RoomSize.y))
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,0),0.5,1,2)
						MovedSouth = true
						set_process_input(false)
						tween.start()
		
		if(((type&1)>>0) == 1):
			if(Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East) == 1):
				var room = Rooms[CurrentRoom]
				if(room.NumConnections(Rooms[room.East[0][0]].West) == 1):
					if(event.scancode == KEY_RIGHT):
						Rooms[CurrentRoom].set_process(false)
						if(CurrentRoom != Rooms[CurrentRoom].East[0][0]):
							tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(-RoomSize.x,0),0.5,1,2)
							CurrentRoom = Rooms[CurrentRoom].East[0][0]
							Rooms[CurrentRoom].show()
						else:
							CreateDummyRoom(Rooms[CurrentRoom])
							DummyRoom.set_pos(Vector2(0,0))
							DummyRoom.show()
							tween.interpolate_property(DummyRoom,"transform/pos",DummyRoom.get_pos(),Vector2(-RoomSize.x,0),0.5,1,2)
						Rooms[CurrentRoom].set_pos(Vector2(RoomSize.x,0))
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,0),0.5,1,2)
						MovedEast = true
						set_process_input(false)
						tween.start()



func CreateDummyRoom(room):
	DummyRoom.Type = room.Type
	DummyRoom.Index = room.Index
	DummyRoom.North = room.North
	DummyRoom.West = room.West
	DummyRoom.South = room.South
	DummyRoom.East = room.East
	DummyRoom.Moving = room.Moving
	DummyRoom.MovingBlock = room.MovingBlock
	DummyRoom.RoomColor = room.RoomColor
	DummyRoom.RoomSize = room.RoomSize
	DummyRoom.BlockSize = room.BlockSize
	DummyRoom.BlocksGridSize = room.BlocksGridSize
	DummyRoom.LevelRooms = room.LevelRooms
	
	
	print("Dummy North: " + str(DummyRoom.North))
	print("Dummy West: " + str(DummyRoom.West))
	print("Dummy South: " + str(DummyRoom.South))
	print("Dummy East: " + str(DummyRoom.East))
	
	DummyRoom.BlocksGrid.clear()
	for x in range(DummyRoom.BlocksGridSize.x):
		DummyRoom.BlocksGrid.append([])
		for y in range(DummyRoom.BlocksGridSize.y):
			DummyRoom.BlocksGrid[x].append(null)
	for i in range(DummyRoom.BlocksArray.size()-1,-1,-1):
		for j in range(DummyRoom.BlocksArray[i].size()-1,-1,-1):
			DummyRoom.remove_child(DummyRoom.BlocksArray[i][j])
	
	DummyRoom.BlocksArray.clear()
	var block = load("res://block.tscn")
	for i in range(room.BlocksArray.size()):
		DummyRoom.BlocksArray.append([])
		for j in range(room.BlocksArray[i].size()):
			var box = block.instance()
			box.Index = room.BlocksArray[i][j].Index
			box.RoomIndex = room.BlocksArray[i][j].RoomIndex
			box.GridP = room.BlocksArray[i][j].GridP
			DummyRoom.BlocksGrid[box.GridP.x][box.GridP.y] = box
			box.BoundingBox = room.BlocksArray[i][j].BoundingBox
			box.PresentRoom = room.BlocksArray[i][j].PresentRoom
			box.LevelRooms = room.BlocksArray[i][j].LevelRooms
			box.set_pos(room.BlocksArray[i][j].get_pos())
			DummyRoom.BlocksArray[i].append(box)
			DummyRoom.add_child(box)

func _on_Tween_tween_complete( object, key ):
	
	DummyRoom.hide()
	
	
	if(MovedNorth):
		tween.remove_all()
		if(CurrentRoom != Rooms[CurrentRoom].South[0][0]):
			var index = Rooms[CurrentRoom].South[0][0]
			Rooms[index].hide()
			if(Rooms[index].BlocksArray.size() > 0):
				for roomblocks in Rooms[index].BlocksArray:
					for block in roomblocks:
						block.set_process(false)
			
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
		MovedNorth = false
		set_process_input(true)
	if(MovedWest):
		tween.remove_all()
		if(CurrentRoom != Rooms[CurrentRoom].East[0][0]):
			var index = Rooms[CurrentRoom].East[0][0]
			Rooms[index].hide()
			if(Rooms[index].BlocksArray.size() > 0):
				for roomblocks in Rooms[index].BlocksArray:
					for block in roomblocks:
						block.set_process(false)
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
		MovedWest = false
		set_process_input(true)
	if(MovedSouth):
		tween.remove_all()
		if(CurrentRoom != Rooms[CurrentRoom].North[0][0]):
			var index = Rooms[CurrentRoom].North[0][0]
			Rooms[index].hide()
			if(Rooms[index].BlocksArray.size() > 0):
				for roomblocks in Rooms[index].BlocksArray:
					for block in roomblocks:
						block.set_process(false)
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
		MovedSouth = false
		set_process_input(true)
	if(MovedEast):
		tween.remove_all()
		if(CurrentRoom != Rooms[CurrentRoom].West[0][0]):
			var index = Rooms[CurrentRoom].West[0][0]
			Rooms[index].hide()
			if(Rooms[index].BlocksArray.size() > 0):
				for roomblocks in Rooms[index].BlocksArray:
					for block in roomblocks:
						block.set_process(false)
		if(Rooms[CurrentRoom].BlocksGrid.size() > 0):
			Rooms[CurrentRoom].set_process(true)
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.set_process(true)
		MovedEast = false
		set_process_input(true)
