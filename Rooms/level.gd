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
var FalseMove = false
var DummyRoom = preload("res://room.tscn").instance()
export var CurrentRoom = 1
onready var tween = get_node("Tween")
onready var tween2 = get_node("Tween2")



func _ready():
	RoomSize.x = get_viewport_rect().size.y
	RoomSize.y = RoomSize.x
	var colors = ColorArray([Color(1,1,1),Color(0,0,1),Color(1,0,0),Color(1,1,0)])
	var temp = 0
	if(temp == 0):
		CurrentRoom = 2
		var room = load("res://room.tscn")
		for i in range(16):
			Rooms.append(room.instance())
			var color
			var index = 0
			if((i&8)>>3 == 1):
				index += 2
			if((i&4)>>2 == 1):
				index += 1
			color = colors[index]
			if((i&2)>>1 == 1):
				color.v *= 0.5
			if((i&1)>>0 == 1):
				color.h *= 0.5
			Rooms[i].RoomColor = color
			Rooms[i].Type = i
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		
		var string = "1,2,2/2,5,2/3,2,4/4,4,5/5,4,4/"
		string += "6,4,2/7,3,2/8,5,5/9,2,5/10,5,3/"
		string += "11,3,3/12,4,3/13,3,5/14,5,4/15,3,4"
		Rooms[7].InitBlocks(string)
		string = "1,1,1/2,3,1/3,5,1/"
		string += "4,2,2/5,4,2/6,6,2/"
		string += "7,1,3/8,3,3/9,5,3/"
		string += "10,2,4/11,4,4/12,6,4/"
		string += "13,1,5/14,3,5/15,5,5"
		Rooms[6].InitBlocks(string)
		Rooms[CurrentRoom].show()
		
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
	elif(temp == 1):
		CurrentRoom = 8
		var room = load("res://room.tscn")
		for i in range(16):
			Rooms.append(room.instance())
			var color
			var index = 0
			if((i&8)>>3 == 1):
				index += 2
			if((i&4)>>2 == 1):
				index += 1
			color = colors[index]
			if((i&2)>>1 == 1):
				color.v *= 0.5
			if((i&1)>>0 == 1):
				color.h *= 0.5
			Rooms[i].RoomColor = color
			Rooms[i].Type = i
			Rooms[i].Index = i
			add_child(Rooms[i])
			Rooms[i].hide()
		var string = "0,2,2/1,3,3/4,4,4/9,5,5"
		Rooms[2].InitBlocks(string)
		string = "6,3,2"
		Rooms[5].InitBlocks(string)
		string = "7,2,1/7,5,6/11,1,2/11,6,5/13,2,3/13,5,4/14,3,2/14,4,5/15,2,2/15,5,5"
		Rooms[1].InitBlocks(string)
		string = "2,5,2/3,2,4/5,3,4/8,2,5/10,4,3/12,4,4"
		Rooms[10].InitBlocks(string)
		string = "0,1,1/1,3,1/2,5,1/3,2,2/4,4,2/5,6,2/6,1,3/8,3,3/9,5,3/10,2,4/12,4,4"
		Rooms[6].InitBlocks(string)
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

func ConnectBlocksOnEdge(h,roomindex):
	if(h[roomindex] == null):
		Rooms[roomindex].ComputeEdgeBlocks()
		h[roomindex] = true
		
		
		var type = Rooms[roomindex].Type
		if((type&8)>>3 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].North) == 1):
				ConnectBlocksOnEdge(h,Rooms[roomindex].North[0][0])
		if((type&4)>>2 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].West) == 1):
				ConnectBlocksOnEdge(h,Rooms[roomindex].West[0][0])
		if((type&2)>>1 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].South) == 1):
				ConnectBlocksOnEdge(h,Rooms[roomindex].South[0][0])
		if((type&1)>>0 == 1):
			if(Rooms[roomindex].NumConnections(Rooms[roomindex].East) == 1):
				ConnectBlocksOnEdge(h,Rooms[roomindex].East[0][0])

func ConnectBlocksInBlocks(h,roomindex):
	if(h[roomindex] == null):
		Rooms[roomindex].ComputeEdgeBlocks()
		h[roomindex] = true
		
		for roomblocks in Rooms[roomindex].BlocksArray:
			for block in roomblocks:
				ConnectBlocksInBlocks(h,block.RoomIndex)



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
			
			Rooms[CurrentRoom].EraseConnections(PickUpBlock.RoomIndex,CurrentRoom)
			Rooms[CurrentRoom].EraseConnections(PickUpBlock.RoomIndex,-CurrentRoom)
			Rooms[CurrentRoom].ComputeMiddleBlocks()
			for n in range(10):
				var h = []
				h.resize(Rooms.size())
				ConnectBlocksOnEdge(h,CurrentRoom)
				for i in range(Rooms.size()):
					if(h[i] == null):
						ConnectBlocksOnEdge(h,i)
			
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
				Rooms[CurrentRoom].ComputeMiddleBlocks()
				for n in range(10):
					var h = []
					h.resize(Rooms.size())
					ConnectBlocksOnEdge(h,CurrentRoom)
					for i in range(Rooms.size()):
						if(h[i] == null):
							ConnectBlocksOnEdge(h,i)
				
				
				
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
				Rooms[PickUpRoom].ComputeMiddleBlocks()
				for n in range(10):
					var h = []
					h.resize(Rooms.size())
					ConnectBlocksOnEdge(h,CurrentRoom)
					for i in range(Rooms.size()):
						if(h[i] == null):
							ConnectBlocksOnEdge(h,i)
				Rooms[PickUpRoom].add_child(PickUpBlock)
			PickUp = false
			PickUpBlock = null




func _input(event):
	if(event.type == InputEvent.KEY and event.is_pressed()):
		
		if(event.scancode == KEY_ESCAPE):
			get_tree().quit()
		
		
		var type = Rooms[CurrentRoom].Type
		if(event.scancode == KEY_UP or event.scancode == KEY_W):
			if(((type&8)>>3) == 1):
				var connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North)
				if(connections == 1):
					var room = Rooms[CurrentRoom]
					if(room.NumConnections(Rooms[room.North[0][0]].South) == 1):
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
				elif(connections == 0):
					tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,RoomSize.y*0.5),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_LEFT or event.scancode == KEY_A):
			if(((type&4)>>2) == 1):
				var connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West)
				if(connections == 1):
					var room = Rooms[CurrentRoom]
					if(room.NumConnections(Rooms[room.West[0][0]].East) == 1):
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
				elif(connections == 0):
					tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(RoomSize.x*0.5,0),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_DOWN or event.scancode == KEY_S):
			if(((type&2)>>1) == 1):
				var connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South)
				if(connections == 1):
					var room = Rooms[CurrentRoom]
					if(room.NumConnections(Rooms[room.South[0][0]].North) == 1):
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
				elif(connections == 0):
					tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,-RoomSize.y*0.5),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_RIGHT or event.scancode == KEY_D):
			if(((type&1)>>0) == 1):
				var connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East)
				if(connections == 1):
					var room = Rooms[CurrentRoom]
					if(room.NumConnections(Rooms[room.East[0][0]].West) == 1):
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
				elif(connections == 0):
					tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(-RoomSize.x*0.5,0),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
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
	
	if(FalseMove):
		tween2.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,0),0.25,0,1,0.25)
		tween2.start()
		FalseMove = false


func _on_Tween2_tween_complete( object, key ):
	tween2.remove_all()
	set_process_input(true)
	set_process(true)
