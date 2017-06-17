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
var DrosteMove = false
var DrosteRoom = -1
var DrosteBox = Rect2()
var GeneratingString = ""
var Count = 0.0
export var CurrentRoom = 1
var DummyRoom = preload("res://room.tscn").instance()
onready var CurrentCamera = get_node("camera")
onready var impossible = get_node("impossible")
onready var tween = get_node("Tween")
onready var tween2 = get_node("Tween2")
onready var main = get_node("../")



func _ready():
	RoomSize.x = get_viewport_rect().size.y
	RoomSize.y = RoomSize.x
	#var texts = ["a4ddab","408365","4f3f2f","206771","449256","3f3f4f","a19758","cbc486","a77a4c","2f3f3f","8a9625","004e52","d0f16f","726346","6e6c5b","6750f0"]
	var texts = ["e5eccb","bb4876","520929","395aba","e5a719","86ac26","fc9ddf","274c4f","e26aa9","867a44","40691d","cd422d","5c6f83","dbdc61","523671","fda12b"]
	#var texts = ["1b61db","0b5556","fb670d","762305","7db49d","faa88f","374b32","ffc32c","5b1b5c","ae280f","7d8633","afd3d5","dbae1d","8b3e0f","2d6f3f","6851f1"]
	var colors = ColorArray()
	for text in texts:
		colors.append(Color(text))
	var room = load("res://room.tscn")
	for i in range(16):
		Rooms.append(room.instance())
		Rooms[i].RoomColor = colors[i]
		Rooms[i].Type = i
		Rooms[i].Index = i
		add_child(Rooms[i])
		Rooms[i].hide()
	
	if(GeneratingString == ""):
		#NOTE(ian): default set-up for rooms
		var string = "8"
		string += "_"
		#string += "0,0,0,0;'0,0,0,1;7,9'0,0,0,0;'0,0,1,1;11,9,15,9'"
		#string += "0,1,0,0;13,9'0,1,0,0;9,9'0,1,1,0;7,9,13,9'0,1,1,1;1,9,15,9,6,9'"
		#string += "0,0,0,0;'1,0,0,1;14,9,5,9'0,0,0,0;'1,0,1,1;"
		string += "_"
		string += "2;"
		string += "10,2,2"
		string += "_"
		string += "9;"
		string += "1,2,2/7,3,2/6,4,2/"
		string += "3,2,3/15,3,3/13,4,3/4,5,3/"
		string += "11,2,4/14,3,4/0,4,4/2,5,4/"
		string += "8,2,5/9,3,5/5,4,5/12,6,5"
		string += "_"
		string += "10;"
		string += "0,2,6/1,1,1/2,3,1/3,5,1/"
		string += "4,2,2/5,4,2/6,6,2/"
		string += "7,1,3/8,3,3/9,5,3/"
		string += "10,2,4/11,4,4/12,6,4/"
		string += "13,1,5/14,3,5/15,5,5"
		GeneratingString = string
	
	var fileparts = GeneratingString.split("_",true)
	CurrentRoom = fileparts[0].to_int()
	var connections = fileparts[1].split("'",false)
	for i in range(connections.size()):
		var roominfo = connections[i].split(";",false)
		if(roominfo.size() > 1):
			var nums = roominfo[0].split(",",false)
			var entries = roominfo[1].split(",",false)
			var k = 0
			for j in range(nums[0].to_int()):
				Rooms[i].North.append([entries[2*(j+k)].to_int(),entries[2*(j+k)+1].to_int()])
			k += nums[0].to_int()
			for j in range(nums[1].to_int()):
				Rooms[i].West.append([entries[2*(j+k)].to_int(),entries[2*(j+k)+1].to_int()])
			k += nums[1].to_int()
			for j in range(nums[2].to_int()):
				Rooms[i].South.append([entries[2*(j+k)].to_int(),entries[2*(j+k)+1].to_int()])
			k += nums[2].to_int()
			for j in range(nums[3].to_int()):
				Rooms[i].East.append([entries[2*(j+k)].to_int(),entries[2*(j+k)+1].to_int()])
			k += nums[3].to_int()
	for i in range(2,fileparts.size()):
		var roomfile = fileparts[i].split(";",false)
		Rooms[roomfile[0].to_int()].InitBlocks(roomfile[1])
	#ComputeEdgeBlocks(CurrentRoom)
	Rooms[CurrentRoom].show()
	
	Rooms[8].add_child(load("res://arrows.tscn").instance())
	Rooms[9].add_child(load("res://mouse.tscn").instance())
	
	
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

func ComputeEdgeBlocks(roomindex):
	for n in range(10):
		var h = []
		h.resize(Rooms.size())
		ConnectBlocksOnEdge(h,roomindex)
		for i in range(Rooms.size()):
			if(h[i] == null):
				ConnectBlocksOnEdge(h,i)



func _process(delta):
	Count += delta
	if(not PickUp):
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				if(block.BoundingBox.has_point(get_global_mouse_pos())):
					if(Input.is_action_pressed("select_block")):
						PickUp = true
						PickUpBlock = block
					block.ColorMod = Vector3(2,2,2)
				else:
					block.ColorMod = Vector3(1,1,1)
		
		if(PickUp):
			PickUpPos = PickUpBlock.GridP
			PickUpRoom = CurrentRoom
			Rooms[CurrentRoom].BlocksGrid[PickUpPos.x][PickUpPos.y] = null
			for roomindex in range(Rooms[CurrentRoom].BlocksArray.size()-1,-1,-1):
				for blockindex in range(Rooms[CurrentRoom].BlocksArray[roomindex].size()-1,-1,-1):
					Rooms[CurrentRoom].BlocksArray[roomindex][blockindex].ColorMod = Vector3(1,1,1)
					if(Rooms[CurrentRoom].BlocksArray[roomindex][blockindex] == PickUpBlock):
						if(Rooms[CurrentRoom].BlocksArray[roomindex].size() == 1):
							Rooms[CurrentRoom].BlocksArray.remove(roomindex)
						else:
							Rooms[CurrentRoom].BlocksArray[roomindex].remove(blockindex)
			
			
			#TODO(ian): The 'EraseEdge' functions are a hack solution. Maybe think of something better?
			Rooms[CurrentRoom].EraseConnections(PickUpBlock.RoomIndex,CurrentRoom)
			if(PickUpPos.y == 0):
				Rooms[CurrentRoom].EraseEdgeNorth(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.x == 0):
				Rooms[CurrentRoom].EraseEdgeWest(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.y == BlocksGridSize.y-1):
				Rooms[CurrentRoom].EraseEdgeSouth(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.x == BlocksGridSize.x-1):
				Rooms[CurrentRoom].EraseEdgeEast(PickUpBlock.RoomIndex,-CurrentRoom)
			Rooms[CurrentRoom].ComputeMiddleBlocks()
			ComputeEdgeBlocks(CurrentRoom)
			
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
				PickUpBlock.ColorMod = Vector3(0.3,0.3,0.3)
			else:
				PickUpBlock.ColorMod = Vector3(1,1,1)
				PickUpRoom = CurrentRoom
				PickUpPos = PickUpBlock.GridP
		else:
			DropBlock()

func DropBlock():
	var BlockSize = Rooms[CurrentRoom].BlockSize
	PickUpBlock.ColorMod = Vector3(1,1,1)
	remove_child(PickUpBlock)
	PickUpBlock.set_scale(Vector2(1,1))
	PickUpBlock.set_z(10)
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
		PickUpBlock.BoundingBox.pos = pos
		BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] = PickUpBlock
		Rooms[CurrentRoom].ComputeMiddleBlocks()
		ComputeEdgeBlocks(CurrentRoom)
		Rooms[CurrentRoom].add_child(PickUpBlock)
		get_node("sfx").play("box")
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
		else:
			get_node("sfx").play("box")
		Rooms[PickUpRoom].ComputeMiddleBlocks()
		ComputeEdgeBlocks(PickUpRoom)
		Rooms[PickUpRoom].add_child(PickUpBlock)
	PickUp = false
	PickUpBlock = null



func SaveGame():
	if(PickUp):
		DropBlock()
	var savedata = str(CurrentRoom) + "_"
	var roomdata = ""
	for room in Rooms:
		roomdata += str(room.North.size()) + ","
		roomdata += str(room.West.size()) + ","
		roomdata += str(room.South.size()) + ","
		roomdata += str(room.East.size()) + ";"
		for entry in room.North:
			roomdata += str(entry[0]) + "," + str(entry[1]) + ","
		for entry in room.West:
			roomdata += str(entry[0]) + "," + str(entry[1]) + ","
		for entry in room.South:
			roomdata += str(entry[0]) + "," + str(entry[1]) + ","
		for entry in room.East:
			roomdata += str(entry[0]) + "," + str(entry[1]) + ","
		roomdata += "'"
	savedata += roomdata
	for i in range(Rooms.size()):
		if(Rooms[i].BlocksArray.size() > 0):
			savedata += "_" + str(i) + ";"
			for roomblocks in Rooms[i].BlocksArray:
				for block in roomblocks:
					var blockdata = str(block.RoomIndex) + ","
					blockdata += str(block.GridP.x) + ","
					blockdata += str(block.GridP.y) + "/"
					savedata += blockdata
	main.savecontent(savedata)



func _input(event):
	if(event.type == InputEvent.KEY and event.is_pressed()):
		
		if(event.scancode == KEY_ESCAPE):
			SaveGame()
			get_tree().quit()
		
		if(event.scancode == KEY_SPACE and Count > 0.1):
			
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					if(block.BoundingBox.has_point(get_global_mouse_pos())):
						DrosteMove = true
						DrosteRoom = block.RoomIndex
						DrosteBox = block.BoundingBox
			
			if(DrosteMove):
				var zoom = Vector2()
				zoom.x = DrosteBox.size.x/get_viewport_rect().size.x
				zoom.y = DrosteBox.size.y/get_viewport_rect().size.y
				
				tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),DrosteBox.pos,1.0,1,2)
				tween.interpolate_property(CurrentCamera,"zoom",CurrentCamera.get_zoom(),zoom,1.0,1,2)
				if(PickUp):
					var BlockSize = Rooms[CurrentRoom].BlockSize
					var pos = DrosteBox.pos
					var shift = Vector2()
					shift.x = BlockSize.x/BlocksGridSize.x
					shift.y = BlockSize.y/BlocksGridSize.y
					pos.x += PickUpBlock.GridP.x*shift.x
					pos.y += PickUpBlock.GridP.y*shift.y
					shift *= 0.25
					pos -= shift
					var scale = Vector2(1,1)
					scale.x /= BlocksGridSize.x
					scale.y /= BlocksGridSize.y
					scale.x *= 1.5
					scale.y *= 1.5
					PickUpBlock.ColorMod = Vector3(1,1,1)
					tween.interpolate_property(PickUpBlock,"transform/scale",PickUpBlock.get_scale(),scale,1.0,1,2)
					tween.interpolate_property(PickUpBlock,"transform/pos",PickUpBlock.get_pos(),pos,1.0,1,2)
				set_process(false)
				set_process_input(false)
				Rooms[CurrentRoom].set_process(false)
				for roomblocks in Rooms[CurrentRoom].BlocksArray:
					for block in roomblocks:
						block.ColorMod = Vector3(1,1,1)
						block.update()
						block.set_process(false)
				DrosteMove = true
				tween.start()
				Count = 0.0
		
		
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
				else:
					if(connections > 1):
						impossible.ShowIndex = 0
						impossible.Count = 0.0
						for entry in Rooms[CurrentRoom].North:
							var roomindex = entry[0]
							if(roomindex == CurrentRoom):
								CreateDummyRoom(Rooms[CurrentRoom])
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(0,-RoomSize.y))
							else:
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(0,-RoomSize.y))
						impossible.set_process(true)
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,-RoomSize.y*0.5),0.25,0,0)
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
				else:
					if(connections > 1):
						impossible.ShowIndex = 0
						impossible.Count = 0.0
						for entry in Rooms[CurrentRoom].West:
							var roomindex = entry[0]
							if(roomindex == CurrentRoom):
								CreateDummyRoom(Rooms[CurrentRoom])
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(-RoomSize.x,0))
							else:
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(-RoomSize.x,0))
						impossible.set_process(true)
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(-RoomSize.x*0.5,0),0.25,0,0)
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
				else:
					if(connections > 1):
						impossible.ShowIndex = 0
						impossible.Count = 0.0
						for entry in Rooms[CurrentRoom].South:
							var roomindex = entry[0]
							if(roomindex == CurrentRoom):
								CreateDummyRoom(Rooms[CurrentRoom])
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(0,RoomSize.y))
							else:
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(0,RoomSize.y))
						impossible.set_process(true)
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,RoomSize.y*0.5),0.25,0,0)
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
				else:
					if(connections > 1):
						impossible.ShowIndex = 0
						impossible.Count = 0.0
						for entry in Rooms[CurrentRoom].East:
							var roomindex = entry[0]
							if(roomindex == CurrentRoom):
								CreateDummyRoom(Rooms[CurrentRoom])
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(RoomSize.x,0))
							else:
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(RoomSize.x,0))
						impossible.set_process(true)
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(RoomSize.x*0.5,0),0.25,0,0)
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
		tween2.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,0),0.25,0,1,0.25)
		tween2.start()
		FalseMove = false
	
	
	if(DrosteMove):
		tween.remove_all()
		Rooms[CurrentRoom].hide()
		CurrentRoom = DrosteRoom
		Rooms[CurrentRoom].show()
		Rooms[CurrentRoom].set_pos(Vector2(0,0))
		Rooms[CurrentRoom].set_process(true)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.set_process(true)
		#var zoomout = Vector2()
		#zoomout.x = get_viewport_rect().size.x/DrosteBox.size.x
		#zoomout.y = get_viewport_rect().size.y/DrosteBox.size.y
		#CurrentCamera.set_zoom(zoomout)
		#CurrentCamera.set_zoom(Vector2(1,1))
		#CurrentCamera.set_pos(Rooms[CurrentRoom].get_pos())
		CurrentCamera.clear_current()
		remove_child(CurrentCamera)
		CurrentCamera = load("res://camera.tscn").instance()
		CurrentCamera.make_current()
		add_child(CurrentCamera)
		set_process(true)
		set_process_input(true)
		if(PickUp):
			PickUpBlock.set_scale(Vector2(1,1))
			var pos = Vector2()
			var BlockSize = Rooms[CurrentRoom].BlockSize
			pos.x = PickUpBlock.GridP.x * BlockSize.x
			pos.y = PickUpBlock.GridP.y * BlockSize.y
			PickUpBlock.set_pos(pos)
		DrosteMove = false
		DrosteRoom = -1


func _on_Tween2_tween_complete( object, key ):
	for room in impossible.RoomCycle:
		room.hide()
	impossible.RoomCycle.clear()
	impossible.set_process(false)
	tween2.remove_all()
	set_process_input(true)
	set_process(true)
