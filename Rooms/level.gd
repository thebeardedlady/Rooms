extends Node2D

var Rooms = []
var MovedNorth = false
var MovedWest = false
var MovedSouth = false
var MovedEast = false
var PickUpRoom = -1
var PickUpPos = Vector2(-1,-1)
var PickUp = false
var PickUpBlock = null
var RoomSize = Vector2(800,800)
var BlocksGridSize = Vector2(8,8)
var DummyRoom = preload("res://room.tscn").instance()
export var CurrentRoom = 1
onready var tween = get_node("Tween")



func _ready():
	RoomSize.x = get_viewport_rect().size.y
	RoomSize.y = RoomSize.x
	
	var temp = 0
	if(temp == 0):
		CurrentRoom = 2
		var room = load("res://room.tscn")
		for i in range(16):
			Rooms.append(room.instance())
			Rooms[i].RoomColor = Color(0.2,0.5,0.3)
			Rooms[i].Type = i
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "1,1,1/2,4,1/3,1,3/4,3,4/5,3,3/"
		string += "6,3,1/7,2,1/8,4,4/9,1,4/10,4,2/"
		string += "11,2,2/12,3,2/13,2,4/14,4,3/15,2,3"
		Rooms[7].InitBlocks(string)
		string = "1,0,0/2,2,0/3,4,0/"
		string += "4,1,1/5,3,1/6,5,1/"
		string += "7,0,2/8,2,2/9,4,2/"
		string += "10,1,3/11,3,3/12,5,3/"
		string += "13,0,4/14,2,4/15,4,4"
		Rooms[6].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 1):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 2):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 3):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 4):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 5):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 6):
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
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	
	DummyRoom.hide()
	add_child(DummyRoom)
	set_process_input(true)
	set_process(true)


func CreateHSVColor(h,s,v):
	var color = Color()
	color.v = v
	color.s = s
	color.h = h
	
	return color

func ConnectRooms(h,roomindex):
	if(h[roomindex] == null):
		Rooms[roomindex].ComputeSingleBlock()
		h[roomindex] = true
		
		var type = Rooms[roomindex].Type
		if((type&8)>>3 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].North) == 1):
				ConnectRooms(h,Rooms[roomindex].North[0][0])
		if((type&4)>>2 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].West) == 1):
				ConnectRooms(h,Rooms[roomindex].West[0][0])
		if((type&2)>>1 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].South) == 1):
				ConnectRooms(h,Rooms[roomindex].South[0][0])
		if((type&1)>>0 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].East) == 1):
				ConnectRooms(h,Rooms[roomindex].East[0][0])
		
		for roomblocks in Rooms[roomindex].BlocksArray:
			for block in roomblocks:
				ConnectRooms(h,block.RoomIndex)



func _process(delta):
	if(not PickUp):
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				if(block.BoundingBox.has_point(get_global_mouse_pos()) and Input.is_action_pressed("select_block")):
					PickUp = true
					PickUpBlock = block
		
		if(PickUp):
			PickUpPos = PickUpBlock.GridP
			PickUpRoom = CurrentRoom
			Rooms[CurrentRoom].BlocksGrid[PickUpPos.x][PickUpPos.y] = null
			for roomindex in range(Rooms[CurrentRoom].BlocksArray.size()-1,-1,-1):
				for blockindex in range(Rooms[CurrentRoom].BlocksArray[roomindex].size()-1,-1,-1):
					if(Rooms[CurrentRoom].BlocksArray[roomindex][blockindex] == PickUpBlock):
						if(Rooms[CurrentRoom].BlocksArray[roomindex].size() == 1):
							Rooms[CurrentRoom].BlocksArray.remove(roomindex)
						else:
							Rooms[CurrentRoom].BlocksArray[roomindex].remove(blockindex)
			
			Rooms[CurrentRoom].EraseConnections(PickUpBlock.RoomIndex,Rooms[CurrentRoom].Index)
			Rooms[CurrentRoom].EraseConnections(PickUpBlock.RoomIndex,-CurrentRoom)
			var h = []
			h.resize(Rooms.size())
			ConnectRooms(h,CurrentRoom)
			for i in range(Rooms.size()):
				if(h[i] == null):
					ConnectRooms(h,i)
			
			Rooms[CurrentRoom].remove_child(PickUpBlock)
			add_child(PickUpBlock)
			PickUpBlock.update()
			PickUpBlock.set_z(100)
	else:
		var BlockSize = Rooms[CurrentRoom].BlockSize
		if(Input.is_action_pressed("select_block")):
			PickUpBlock.set_scale(Vector2(1.5,1.5))
			var rect = Rect2(0,0,BlocksGridSize.x-0.5,BlocksGridSize.y-0.5)
			var mousepos = get_global_mouse_pos()-(BlockSize*0.5)
			mousepos = mousepos.snapped(BlockSize)
			var temppos = mousepos
			temppos.x /= BlockSize.x
			temppos.y /= BlockSize.y
			if(rect.has_point(temppos)):
				PickUpBlock.GridP = temppos
				PickUpBlock.BoundingBox.pos = mousepos
			var shift = (BlockSize*0.5)*0.5
			PickUpBlock.set_pos(PickUpBlock.BoundingBox.pos-shift)
			var BlocksGrid = Rooms[CurrentRoom].BlocksGrid
			if(BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] != null):
				PickUpBlock.ColorMod = Vector3(1.5,0.5,0.5)
			else:
				PickUpBlock.ColorMod = Vector3(1,1,1)
		else:
			PickUpBlock.ColorMod = Vector3(1,1,1)
			remove_child(PickUpBlock)
			PickUpBlock.set_scale(Vector2(1,1))
			PickUpBlock.set_z(0)
			var BlocksGrid = Rooms[CurrentRoom].BlocksGrid
			if(BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] == null):
				var index = -1
				var BlocksArray = Rooms[CurrentRoom].BlocksArray
				for roomindex in range(BlocksArray.size()):
					if(BlocksArray[roomindex][0].RoomIndex == PickUpBlock.RoomIndex):
						index = roomindex
				if(index == -1):
					BlocksArray.append([PickUpBlock])
				else:
					BlocksArray[index].append(PickUpBlock)
				
				var pos = PickUpBlock.GridP
				pos.x *= BlockSize.x
				pos.y *= BlockSize.y
				PickUpBlock.set_pos(pos)
				BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] = PickUpBlock
				var h = []
				h.resize(Rooms.size())
				ConnectRooms(h,PickUpBlock.RoomIndex)
				ConnectRooms(h,CurrentRoom)
				for i in range(Rooms.size()):
					if(h[i] == null):
						ConnectRooms(h,i)
				Rooms[CurrentRoom].add_child(PickUpBlock)
			else:
				var index = -1
				BlocksGrid = Rooms[PickUpRoom].BlocksGrid
				var BlocksArray = Rooms[PickUpRoom].BlocksArray
				for roomindex in range(BlocksArray.size()):
					if(BlocksArray[roomindex][0].RoomIndex == PickUpBlock.RoomIndex):
						index = roomindex
				if(index == -1):
					BlocksArray.append([PickUpBlock])
				else:
					BlocksArray[index].append(PickUpBlock)
				PickUpBlock.GridP = PickUpPos
				BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] = PickUpBlock
				var pos = PickUpBlock.GridP
				pos.x *= BlockSize.x
				pos.y *= BlockSize.y
				PickUpBlock.set_pos(pos)
				PickUpBlock.BoundingBox.pos = pos
				if(PickUpRoom != CurrentRoom):
					PickUpBlock.set_process(false)
				var h = []
				h.resize(Rooms.size())
				ConnectRooms(h,PickUpBlock.RoomIndex)
				ConnectRooms(h,PickUpRoom)
				for i in range(Rooms.size()):
					if(h[i] == null):
						ConnectRooms(h,i)
				Rooms[PickUpRoom].add_child(PickUpBlock)
			PickUp = false
			PickUpBlock = null




func _input(event):
	if(event.type == InputEvent.KEY and event.is_pressed()):
		
		if(event.scancode == KEY_ESCAPE):
			get_tree().quit()
		var type = Rooms[CurrentRoom].Type
		if(((type&8)>>3) == 1):
			if(Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North) == 1):
				var room = Rooms[CurrentRoom]
				if(room.NumConnections(Rooms[room.North[0][0]].South) == 1):
					if(event.scancode == KEY_UP or event.scancode == KEY_W):
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
					if(event.scancode == KEY_LEFT or event.scancode == KEY_A):
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
					if(event.scancode == KEY_DOWN or event.scancode == KEY_S):
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
					if(event.scancode == KEY_RIGHT or event.scancode == KEY_D):
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
	DummyRoom.RoomColor = room.RoomColor
	DummyRoom.RoomSize = room.RoomSize
	DummyRoom.BlockSize = room.BlockSize
	DummyRoom.BlocksGridSize = room.BlocksGridSize
	DummyRoom.Rooms = room.Rooms
	
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
			box.Rooms = room.BlocksArray[i][j].Rooms
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
			for roomblocks in Rooms[index].BlocksArray:
				for block in roomblocks:
					block.set_process(false)
			
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
			for roomblocks in Rooms[index].BlocksArray:
				for block in roomblocks:
					block.set_process(false)
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
			for roomblocks in Rooms[index].BlocksArray:
				for block in roomblocks:
					block.set_process(false)
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
			for roomblocks in Rooms[index].BlocksArray:
				for block in roomblocks:
					block.set_process(false)
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
		MovedEast = false
		set_process_input(true)
