extends Node2D

var Rooms = []
var Music = 1
var ColorScheme = 1
var MovedNorth = false
var MovedWest = false
var MovedSouth = false
var MovedEast = false
var PickUpRoom = -1
var PickUpPos = Vector2(-1,-1)
var PickUp = false
var PickUpBlock = null
var RoomSize = Vector2(512,512)
var BlocksGridSize = Vector2(9,9)
var FalseMove = false
var RotatingMove = false
var DrosteMove = false
var DrosteRoom = -1
var DrosteBox = Rect2()
var DrosteBlock = null
var DrosteOrient = 3
var GeneratingString = ""
var Count = 0.0
export var CurrentRoom = 1
var DummyRoom = preload("res://room.tscn").instance()
onready var CurrentCamera = get_node("camera")
onready var impossible = get_node("impossible")
onready var tween = get_node("Tween")
onready var tween2 = get_node("Tween2")
onready var main = get_node("../")
var ColorsOne = ["e5eccb","9b98f6","520929","86ac26","e5a719","395afa","fc9ddf","274c4f","e26aa9","867a44","40691d","cd422d","5c6f83","dbdc61","523671","fda12b"]
var ColorsTwo = ["a4ddab","400325","4f3f2f","206771","449256","3f3f4f","a19758","cbc486","a77a4c","2f3f3f","8a9625","004e52","d0f16f","726346","6e6c5b","6750f0"]
var ColorsThree = ["1b61db","bbb556","fb670d","702005","7db49d","faa88f","374b32","ffc32c","5b1b5c","ae280f","7d8633","afd3d5","dbae1d","0b3e0f","2d6f3f","6851f1"]


func _ready():
	RoomSize.x = get_viewport_rect().size.x
	RoomSize.y = get_viewport_rect().size.y
	
	
	if(GeneratingString == "1"):
		#NOTE(ian): default set-up for Level One
		var string = "8,3," + str(ColorScheme) + "," + str(Music)
		string += "_"
		string += "_"
		string += "1;"
		string += "3,2,2,3/6,3,2,3/"
		string += "9,2,3,3/12,3,3,3"
		string += "?"
		string += "2;"
		string += "0,2,2,3/15,6,2,3"
		string += "?"
		string += "5;"
		string += "2,4,2,3/10,4,3,3/"
		string += "1,2,4,3/7,3,4,3/14,4,4,3/"
		string += "11,3,5,3/13,4,5,3/5,5,5,3/4,6,5,3/"
		string += "8,3,6,3"
		GeneratingString = string
	if(GeneratingString == "2"):
		#NOTE(ian): default set-up for Level Two
		
		var string = "8,3," + str(ColorScheme) + "," + str(Music)
		string += "_"
		string += "_"
		string += "2;"
		string += "7,6,4,3/7,7,3,3/10,1,1,3/10,2,2,3/"
		string += "1,5,1,3/1,3,1,3/14,6,6,3/14,7,5,3/"
		string += "3,6,2,3/3,7,1,3/15,4,4,3/15,4,2,3/"
		string += "4,3,3,3/4,5,3,3/12,2,4,3/12,1,3,3/"
		string += "13,3,5,3/13,5,5,3/11,1,5,3/11,2,6,3/0,4,6,3/"
		string += "?"
		string += "5;"
		string += "5,3,3,3/5,5,3,3/6,6,3,3/6,5,6,3/"
		string += "8,6,4,3/8,5,7,3/9,2,3,3/9,3,6,3/"
		string += "2,2,2,3/2,3,5,3/0,4,6,3/"
		GeneratingString = string
	
	
	var fileparts = GeneratingString.split("_",true)
	var header = fileparts[0].split(",",false)
	CurrentRoom = header[0].to_int()
	
	
	ColorScheme = header[2].to_int()
	var texts
	if(ColorScheme == 1):
		texts = ColorsOne
	elif(ColorScheme == 2):
		texts = ColorsTwo
	elif(ColorScheme == 3):
		texts = ColorsThree
	
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
	
	
	Rooms[CurrentRoom].Orientation = header[1].to_int()
	Music = header[3].to_int()
	if(Music == 0):
		main.get_node("music").stop()
		main.get_node("Music Button").set_text("Music: off")
	else:
		if(not main.get_node("music").is_playing()):
			main.get_node("music").play()
		main.get_node("Music Button").set_text("Music: on")
	
	if(Rooms[CurrentRoom].Orientation == 3):
		Rooms[CurrentRoom].set_rotd(0)
	elif(Rooms[CurrentRoom].Orientation == 2):
		Rooms[CurrentRoom].set_rotd(90)
	elif(Rooms[CurrentRoom].Orientation == 1):
		Rooms[CurrentRoom].set_rotd(180)
	else:
		Rooms[CurrentRoom].set_rotd(270)
	var connections = fileparts[1].split("?",false)
	for i in range(connections.size()):
		var roominfo = connections[i].split(";",false)
		if(roominfo.size() > 1):
			var nums = roominfo[0].split(",",false)
			var entries = roominfo[1].split(",",false)
			var k = 0
			for j in range(nums[0].to_int()):
				Rooms[i].North.append([entries[3*(j+k)].to_int(),entries[3*(j+k)+1].to_int(),entries[3*(j+k)+2]])
			k += nums[0].to_int()
			for j in range(nums[1].to_int()):
				Rooms[i].West.append([entries[3*(j+k)].to_int(),entries[3*(j+k)+1].to_int(),entries[3*(j+k)+2]])
			k += nums[1].to_int()
			for j in range(nums[2].to_int()):
				Rooms[i].South.append([entries[3*(j+k)].to_int(),entries[3*(j+k)+1].to_int(),entries[3*(j+k)+2]])
			k += nums[2].to_int()
			for j in range(nums[3].to_int()):
				Rooms[i].East.append([entries[3*(j+k)].to_int(),entries[3*(j+k)+1].to_int(),entries[3*(j+k)+2]])
			k += nums[3].to_int()
	for roomfile in fileparts[2].split("?",false):
		var roomsplit = roomfile.split(";",false)
		Rooms[roomsplit[0].to_int()].InitBlocks(roomsplit[1])
	#ComputeEdgeBlocks(CurrentRoom)
	Rooms[CurrentRoom].show()
	
	Rooms[8].add_child(load("res://arrows.tscn").instance())
	Rooms[5].add_child(load("res://mouse.tscn").instance())
	
	
	#Rooms[CurrentRoom].update()
	#for roomblocks in Rooms[CurrentRoom].BlocksArray:
	#	for block in roomblocks:
	#		block.update()
	
	
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
		#var h = []
		#h.resize(Rooms.size())
		#ConnectBlocksOnEdge(h,roomindex)
		for i in range(Rooms.size()):
			#if(h[i] == null):
			#	ConnectBlocksOnEdge(h,i)
			Rooms[i].ComputeEdgeBlocks()



func _process(delta):
	Count += delta
	if(not PickUp):
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				if(block.MouseOver):
					if(Input.is_action_pressed("select_block")):
						PickUp = true
						PickUpBlock = block
					else:
						if(Input.is_action_pressed("rotate_block")):
							block.Orientation = (block.Orientation + 3) % 4
							block.set_z(20)
							tween.interpolate_property(block,"transform/rot",block.get_rotd(),block.get_rotd() + 90,0.2,0,1)
							RotatingMove = true
							set_process(false)
							set_process_input(false)
							tween.start()
					block.ColorMod = Vector3(2,2,2)
					block.update()
				else:
					if(block.ColorMod != Vector3(1,1,1)):
						block.update()
					block.ColorMod = Vector3(1,1,1)
		
		if(PickUp):
			#TODO(ian): Change what PickUpPos does maybe?
			PickUpPos = PickUpBlock.GridP
			PickUpRoom = CurrentRoom
			Rooms[CurrentRoom].BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] = null
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
				if(PickUpBlock.Orientation == 3):
					Rooms[CurrentRoom].EraseEdgeNorth(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 2):
					Rooms[CurrentRoom].EraseEdgeEast(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 1):
					Rooms[CurrentRoom].EraseEdgeSouth(PickUpBlock.RoomIndex,-CurrentRoom)
				else:
					Rooms[CurrentRoom].EraseEdgeWest(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.x == 0):
				if(PickUpBlock.Orientation == 3):
					Rooms[CurrentRoom].EraseEdgeWest(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 2):
					Rooms[CurrentRoom].EraseEdgeNorth(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 1):
					Rooms[CurrentRoom].EraseEdgeEast(PickUpBlock.RoomIndex,-CurrentRoom)
				else:
					Rooms[CurrentRoom].EraseEdgeSouth(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.y == BlocksGridSize.y-1):
				if(PickUpBlock.Orientation == 3):
					Rooms[CurrentRoom].EraseEdgeSouth(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 2):
					Rooms[CurrentRoom].EraseEdgeWest(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 1):
					Rooms[CurrentRoom].EraseEdgeNorth(PickUpBlock.RoomIndex,-CurrentRoom)
				else:
					Rooms[CurrentRoom].EraseEdgeEast(PickUpBlock.RoomIndex,-CurrentRoom)
			if(PickUpPos.x == BlocksGridSize.x-1):
				if(PickUpBlock.Orientation == 3):
					Rooms[CurrentRoom].EraseEdgeEast(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 2):
					Rooms[CurrentRoom].EraseEdgeSouth(PickUpBlock.RoomIndex,-CurrentRoom)
				elif(PickUpBlock.Orientation == 1):
					Rooms[CurrentRoom].EraseEdgeWest(PickUpBlock.RoomIndex,-CurrentRoom)
				else:
					Rooms[CurrentRoom].EraseEdgeNorth(PickUpBlock.RoomIndex,-CurrentRoom)
			Rooms[CurrentRoom].ComputeMiddleBlocks()
			ComputeEdgeBlocks(CurrentRoom)
			
			Rooms[CurrentRoom].remove_child(PickUpBlock)
			add_child(PickUpBlock)
			if(Rooms[CurrentRoom].Orientation == 3):
				if(PickUpBlock.Orientation == 3):
					PickUpBlock.set_rotd(0)
				elif(PickUpBlock.Orientation == 2):
					PickUpBlock.set_rotd(90)
				elif(PickUpBlock.Orientation == 1):
					PickUpBlock.set_rotd(180)
				else:
					PickUpBlock.set_rotd(270)
			elif(Rooms[CurrentRoom].Orientation == 2):
				if(PickUpBlock.Orientation == 3):
					PickUpBlock.Orientation = 2
					PickUpBlock.set_rotd(90)
				elif(PickUpBlock.Orientation == 2):
					PickUpBlock.Orientation = 1
					PickUpBlock.set_rotd(180)
				elif(PickUpBlock.Orientation == 1):
					PickUpBlock.Orientation = 0
					PickUpBlock.set_rotd(270)
				else:
					PickUpBlock.Orientation = 3
					PickUpBlock.set_rotd(0)
			elif(Rooms[CurrentRoom].Orientation == 1):
				if(PickUpBlock.Orientation == 3):
					PickUpBlock.Orientation = 1
					PickUpBlock.set_rotd(180)
				elif(PickUpBlock.Orientation == 2):
					PickUpBlock.Orientation = 0
					PickUpBlock.set_rotd(270)
				elif(PickUpBlock.Orientation == 1):
					PickUpBlock.Orientation = 3
					PickUpBlock.set_rotd(0)
				else:
					PickUpBlock.Orientation = 2
					PickUpBlock.set_rotd(90)
			else:
				if(PickUpBlock.Orientation == 3):
					PickUpBlock.Orientation = 0
					PickUpBlock.set_rotd(270)
				elif(PickUpBlock.Orientation == 2):
					PickUpBlock.Orientation = 3
					PickUpBlock.set_rotd(0)
				elif(PickUpBlock.Orientation == 1):
					PickUpBlock.Orientation = 2
					PickUpBlock.set_rotd(90)
				else:
					PickUpBlock.Orientation = 1
					PickUpBlock.set_rotd(180)
			PickUpBlock.update()
			PickUpBlock.set_z(100)
			
			Rooms[CurrentRoom].update()
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					block.update()
	else:
		#TODO(ian): this needs major revision
		var BlockSize = Rooms[CurrentRoom].BlockSize
		if(Input.is_action_pressed("select_block")):
			PickUpBlock.set_scale(Vector2(1.5,1.5))
			var rect = Rect2((BlocksGridSize.x - 1) * -0.5,(BlocksGridSize.y - 1) * -0.5,BlocksGridSize.x - 0.5,BlocksGridSize.y - 0.5)
			var mousepos = get_global_mouse_pos()
			mousepos = mousepos.snapped(BlockSize)
			var temppos = mousepos
			temppos.x /= BlockSize.x
			temppos.y /= BlockSize.y
			#TODO(ian): Is this check really necessary?
			if(rect.has_point(temppos)):
				#NOTE(ian): the subtraction of (1,1) from BlocksGridSize is for odd grids only
				if(Rooms[CurrentRoom].Orientation == 3):
					PickUpBlock.GridP = temppos + 0.5 * (BlocksGridSize - Vector2(1,1))
				elif(Rooms[CurrentRoom].Orientation == 2):
					PickUpBlock.GridP = ComplexMult(temppos,Vector2(0,1)) + 0.5 * (BlocksGridSize - Vector2(1,1))
				elif(Rooms[CurrentRoom].Orientation == 1):
					PickUpBlock.GridP = ComplexMult(temppos,Vector2(-1,0)) + 0.5 * (BlocksGridSize - Vector2(1,1))
				else:
					PickUpBlock.GridP = ComplexMult(temppos,Vector2(0,-1)) + 0.5 * (BlocksGridSize - Vector2(1,1))
				PickUpBlock.BoundingBox.pos = mousepos
			PickUpBlock.set_pos(PickUpBlock.BoundingBox.pos)
			var BlocksGrid = Rooms[CurrentRoom].BlocksGrid
			if(BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] != null):
				PickUpBlock.ColorMod = Vector3(0.3,0.3,0.3)
			else:
				PickUpBlock.ColorMod = Vector3(1,1,1)
				PickUpRoom = CurrentRoom
				PickUpPos = PickUpBlock.GridP
			PickUpBlock.update()
			if(Input.is_action_pressed("rotate_block")):
				PickUpBlock.Orientation = (PickUpBlock.Orientation + 3) % 4
				tween.interpolate_property(PickUpBlock,"transform/rot",PickUpBlock.get_rotd(),PickUpBlock.get_rotd() + 90,0.2,0,1)
				RotatingMove = true
				set_process(false)
				set_process_input(false)
				tween.start()
		else:
			DropBlock()

func ComplexMult(a,b):
	var c = Vector2()
	c.x = a.x*b.x - a.y*b.y
	c.y = a.x*b.y + a.y*b.x
	return c



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
		pos = pos - 0.5 * (BlocksGridSize - Vector2(1,1))
		pos.x *= BlockSize.x
		pos.y *= BlockSize.y
		PickUpBlock.set_pos(pos)
		#print(str(PickUpBlock.GridP))
		
		#PickUpBlock.BoundingBox.pos = pos
		BlocksGrid[PickUpBlock.GridP.x][PickUpBlock.GridP.y] = PickUpBlock
		if(Rooms[CurrentRoom].Orientation == 3):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			else:
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
		elif(Rooms[CurrentRoom].Orientation == 2):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			else:
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(90)
		elif(Rooms[CurrentRoom].Orientation == 1):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			else:
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
		else:
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			else:
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
		Rooms[CurrentRoom].ComputeMiddleBlocks()
		ComputeEdgeBlocks(CurrentRoom)
		Rooms[CurrentRoom].add_child(PickUpBlock)
		#get_node("sfx").play("box")
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
		pos = pos - 0.5 * (BlocksGridSize - Vector2(1,1))
		pos.x *= BlockSize.x
		pos.y *= BlockSize.y
		PickUpBlock.set_pos(pos)
		#print(str(PickUpBlock.GridP))
		
		
		PickUpBlock.BoundingBox.pos = pos
		if(Rooms[PickUpRoom].Orientation == 3):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			else:
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
		elif(Rooms[PickUpRoom].Orientation == 2):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			else:
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(90)
		elif(Rooms[PickUpRoom].Orientation == 1):
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
			else:
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
		else:
			if(PickUpBlock.Orientation == 3):
				PickUpBlock.Orientation = 2
				PickUpBlock.set_rotd(90)
			elif(PickUpBlock.Orientation == 2):
				PickUpBlock.Orientation = 1
				PickUpBlock.set_rotd(180)
			elif(PickUpBlock.Orientation == 1):
				PickUpBlock.Orientation = 0
				PickUpBlock.set_rotd(270)
			else:
				PickUpBlock.Orientation = 3
				PickUpBlock.set_rotd(0)
		if(PickUpRoom != CurrentRoom):
			pass
		else:
			#get_node("sfx").play("box")
			pass
		Rooms[PickUpRoom].ComputeMiddleBlocks()
		ComputeEdgeBlocks(PickUpRoom)
		Rooms[PickUpRoom].add_child(PickUpBlock)
	PickUp = false
	PickUpBlock = null
	
	Rooms[CurrentRoom].update()
	for roomblocks in Rooms[CurrentRoom].BlocksArray:
		for block in roomblocks:
			block.update()



func SaveGame(path):
	if(PickUp):
		#TODO(ian): Depending on how DropBlock() changes this may need to be revised
		DropBlock()
	var savedata = str(CurrentRoom) + "," +  str(Rooms[CurrentRoom].Orientation) + "," + str(ColorScheme) + "," + str(Music) + "_"
	var roomdata = ""
	for room in Rooms:
		roomdata += str(room.North.size()) + ","
		roomdata += str(room.West.size()) + ","
		roomdata += str(room.South.size()) + ","
		roomdata += str(room.East.size()) + ";"
		for entry in room.North:
			roomdata += str(entry[0]) + "," + str(entry[1]) + "," + str(entry[2]) + ","
		for entry in room.West:
			roomdata += str(entry[0]) + "," + str(entry[1]) + "," + str(entry[2]) + ","
		for entry in room.South:
			roomdata += str(entry[0]) + "," + str(entry[1]) + "," + str(entry[2]) + ","
		for entry in room.East:
			roomdata += str(entry[0]) + "," + str(entry[1]) + "," + str(entry[2]) + ","
		roomdata += "?"
	savedata += roomdata + "_"
	for i in range(Rooms.size()):
		if(Rooms[i].BlocksArray.size() > 0):
			savedata += "?" + str(i) + ";"
			for roomblocks in Rooms[i].BlocksArray:
				for block in roomblocks:
					var blockdata = str(block.RoomIndex) + ","
					blockdata += str(block.GridP.x) + ","
					blockdata += str(block.GridP.y) + ","
					blockdata += str(block.Orientation) + "/"
					savedata += blockdata
	main.SaveContent(savedata,path)



func _input(event):
	if(event.type == InputEvent.KEY and event.is_pressed()):
		#TODO(ian): This doesn't work anymore!!!!!
		if(event.scancode == KEY_SPACE and Count > 0.0):
			
			for roomblocks in Rooms[CurrentRoom].BlocksArray:
				for block in roomblocks:
					if(block.MouseOver):
						DrosteMove = true
						DrosteRoom = block.RoomIndex
						if(Rooms[CurrentRoom].Orientation == 3):
							DrosteOrient = block.Orientation
						elif(Rooms[CurrentRoom].Orientation == 2):
							if(block.Orientation == 3):
								DrosteOrient = 2
							elif(block.Orientation == 2):
								DrosteOrient = 1
							elif(block.Orientation == 1):
								DrosteOrient = 0
							else:
								DrosteOrient = 3
						elif(Rooms[CurrentRoom].Orientation == 1):
							if(block.Orientation == 3):
								DrosteOrient = 1
							elif(block.Orientation == 2):
								DrosteOrient = 0
							elif(block.Orientation == 1):
								DrosteOrient = 3
							else:
								DrosteOrient = 2
						else:
							if(block.Orientation == 3):
								DrosteOrient = 0
							elif(block.Orientation == 2):
								DrosteOrient = 3
							elif(block.Orientation == 1):
								DrosteOrient = 2
							else:
								DrosteOrient = 1
						DrosteBox = block.BoundingBox
						DrosteBlock = block
			
			if(DrosteMove):
				var zoom = Vector2()
				zoom.x = DrosteBox.size.x/get_viewport_rect().size.x
				zoom.y = DrosteBox.size.y/get_viewport_rect().size.y
				var CameraPos = DrosteBlock.get_pos()
				if(Rooms[CurrentRoom].Orientation == 3):
					pass
				elif(Rooms[CurrentRoom].Orientation == 2):
					CameraPos = ComplexMult(CameraPos, Vector2(0,-1))
				elif(Rooms[CurrentRoom].Orientation == 1):
					CameraPos = ComplexMult(CameraPos, Vector2(-1,0))
				else:
					CameraPos = ComplexMult(CameraPos, Vector2(0,1))
				
				tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),CameraPos,1.0,0,3) #1.0,1,2
				tween.interpolate_property(CurrentCamera,"zoom",CurrentCamera.get_zoom(),zoom,1.0,0,3)
				if(PickUp):
					var BlockSize = Rooms[CurrentRoom].BlockSize
					var pos = DrosteBlock.get_pos()
					var shift = Vector2()
					shift.x = BlockSize.x/BlocksGridSize.x
					shift.y = BlockSize.y/BlocksGridSize.y
					pos.x += (PickUpBlock.GridP.x - ((BlocksGridSize.x - 1) * 0.5))*shift.x
					pos.y += (PickUpBlock.GridP.y - ((BlocksGridSize.y - 1) * 0.5))*shift.y
					var scale = Vector2(1,1)
					scale.x /= BlocksGridSize.x
					scale.y /= BlocksGridSize.y
					scale.x *= 1.5
					scale.y *= 1.5
					PickUpBlock.ColorMod = Vector3(1,1,1)
					tween.interpolate_property(PickUpBlock,"transform/scale",PickUpBlock.get_scale(),scale,1.0,0,3)
					tween.interpolate_property(PickUpBlock,"transform/pos",PickUpBlock.get_pos(),pos,1.0,0,3)
				set_process(false)
				set_process_input(false)
				for roomblocks in Rooms[CurrentRoom].BlocksArray:
					for block in roomblocks:
						block.ColorMod = Vector3(1,1,1)
						block.update()
				DrosteMove = true
				tween.start()
				Count = 0.0
		
		
		var type = Rooms[CurrentRoom].Type
		if(event.scancode == KEY_UP or event.scancode == KEY_W):
			var hasdoor
			var direction
			if(Rooms[CurrentRoom].Orientation == 3):
				hasdoor = (type&8)>>3
				direction = 3
			elif(Rooms[CurrentRoom].Orientation == 2):
				hasdoor = (type&1)>>0
				direction = 0
			elif(Rooms[CurrentRoom].Orientation == 1):
				hasdoor = (type&2)>>1
				direction = 1
			else:
				hasdoor = (type&4)>>2
				direction = 2
			if(hasdoor == 1):
				var connections
				if(direction == 3):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North)
				elif(direction == 2):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West)
				elif(direction == 1):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South)
				else:
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East)
				if(connections == 1):
					var nextRoom
					var whichdoor
					if(direction == 3):
						nextRoom = Rooms[CurrentRoom].North[0][0]
						whichdoor = Rooms[CurrentRoom].North[0][2]
					elif(direction == 2):
						nextRoom = Rooms[CurrentRoom].West[0][0]
						whichdoor = Rooms[CurrentRoom].West[0][2]
					elif(direction == 1):
						nextRoom = Rooms[CurrentRoom].South[0][0]
						whichdoor = Rooms[CurrentRoom].South[0][2]
					else:
						nextRoom = Rooms[CurrentRoom].East[0][0]
						whichdoor = Rooms[CurrentRoom].East[0][2]
					if(CurrentRoom != nextRoom):
						Rooms[CurrentRoom].set_process(false)
						#TODO(ian): Change the Position where the rooms go after the interpolation
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,RoomSize.y),0.5,1,2)
						CurrentRoom = nextRoom
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						else:
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						Rooms[CurrentRoom].show()
					else:
						CreateDummyRoom(Rooms[CurrentRoom],Rooms[CurrentRoom].Orientation)
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						else:
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
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
						var roomArray
						if(Rooms[CurrentRoom].Orientation == 3):
							roomArray = Rooms[CurrentRoom].North
						elif(Rooms[CurrentRoom].Orientation == 2):
							roomArray = Rooms[CurrentRoom].East
						elif(Rooms[CurrentRoom].Orientation == 1):
							roomArray = Rooms[CurrentRoom].South
						else:
							roomArray = Rooms[CurrentRoom].West
						for entry in roomArray:
							var roomindex = entry[0]
							var whichdoor = entry[2]
							if(roomindex == CurrentRoom):
								if(whichdoor == 3):
									CreateDummyRoom(Rooms[CurrentRoom],1)
								elif(whichdoor == 2):
									CreateDummyRoom(Rooms[CurrentRoom],2)
								elif(whichdoor == 1):
									CreateDummyRoom(Rooms[CurrentRoom],3)
								else:
									CreateDummyRoom(Rooms[CurrentRoom],0)
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(0,-RoomSize.y))
							else:
								if(whichdoor == 3):
									Rooms[roomindex].Orientation = 1
									Rooms[roomindex].set_rotd(180)
								elif(whichdoor == 2):
									Rooms[roomindex].Orientation = 2
									Rooms[roomindex].set_rotd(90)
								elif(whichdoor == 1):
									Rooms[roomindex].Orientation = 3
									Rooms[roomindex].set_rotd(0)
								else:
									Rooms[roomindex].Orientation = 0
									Rooms[roomindex].set_rotd(270)
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(0,-RoomSize.y))
						impossible.set_process(true)
					if(PickUp):
						DropBlock()
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,-RoomSize.y*0.5),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_LEFT or event.scancode == KEY_A):
			var hasdoor
			var direction
			if(Rooms[CurrentRoom].Orientation == 3):
				hasdoor = (type&4)>>2
				direction = 2
			elif(Rooms[CurrentRoom].Orientation == 2):
				hasdoor = (type&8)>>3
				direction = 3
			elif(Rooms[CurrentRoom].Orientation == 1):
				hasdoor = (type&1)>>0
				direction = 0
			else:
				hasdoor = (type&2)>>1
				direction = 1
			if(hasdoor == 1):
				var connections
				if(direction == 3):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North)
				elif(direction == 2):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West)
				elif(direction == 1):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South)
				else:
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East)
				if(connections == 1):
					var nextRoom
					var whichdoor
					if(direction == 3):
						nextRoom = Rooms[CurrentRoom].North[0][0]
						whichdoor = Rooms[CurrentRoom].North[0][2]
					elif(direction == 2):
						nextRoom = Rooms[CurrentRoom].West[0][0]
						whichdoor = Rooms[CurrentRoom].West[0][2]
					elif(direction == 1):
						nextRoom = Rooms[CurrentRoom].South[0][0]
						whichdoor = Rooms[CurrentRoom].South[0][2]
					else:
						nextRoom = Rooms[CurrentRoom].East[0][0]
						whichdoor = Rooms[CurrentRoom].East[0][2]
					if(CurrentRoom != nextRoom):
						Rooms[CurrentRoom].set_process(false)
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(RoomSize.x,0),0.5,1,2)
						CurrentRoom = nextRoom
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						else:
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						Rooms[CurrentRoom].show()
					else:
						CreateDummyRoom(Rooms[CurrentRoom],Rooms[CurrentRoom].Orientation)
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						else:
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
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
						var roomArray
						if(Rooms[CurrentRoom].Orientation == 3):
							roomArray = Rooms[CurrentRoom].West
						elif(Rooms[CurrentRoom].Orientation == 2):
							roomArray = Rooms[CurrentRoom].North
						elif(Rooms[CurrentRoom].Orientation == 1):
							roomArray = Rooms[CurrentRoom].East
						else:
							roomArray = Rooms[CurrentRoom].South
						for entry in roomArray:
							var roomindex = entry[0]
							var whichdoor = entry[2]
							if(roomindex == CurrentRoom):
								if(whichdoor == 3):
									CreateDummyRoom(Rooms[CurrentRoom],0)
								elif(whichdoor == 2):
									CreateDummyRoom(Rooms[CurrentRoom],1)
								elif(whichdoor == 1):
									CreateDummyRoom(Rooms[CurrentRoom],2)
								else:
									CreateDummyRoom(Rooms[CurrentRoom],3)
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(-RoomSize.x,0))
							else:
								if(whichdoor == 3):
									Rooms[roomindex].Orientation = 0
									Rooms[roomindex].set_rotd(270)
								elif(whichdoor == 2):
									Rooms[roomindex].Orientation = 1
									Rooms[roomindex].set_rotd(180)
								elif(whichdoor == 1):
									Rooms[roomindex].Orientation = 2
									Rooms[roomindex].set_rotd(90)
								else:
									Rooms[roomindex].Orientation = 3
									Rooms[roomindex].set_rotd(0)
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(-RoomSize.x,0))
						impossible.set_process(true)
					if(PickUp):
						DropBlock()
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(-RoomSize.x*0.5,0),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_DOWN or event.scancode == KEY_S):
			var hasdoor
			var direction
			if(Rooms[CurrentRoom].Orientation == 3):
				hasdoor = (type&2)>>1
				direction = 1
			elif(Rooms[CurrentRoom].Orientation == 2):
				hasdoor = (type&4)>>2
				direction = 2
			elif(Rooms[CurrentRoom].Orientation == 1):
				hasdoor = (type&8)>>3
				direction = 3
			else:
				hasdoor = (type&1)>>0
				direction = 0
			if(hasdoor == 1):
				var connections
				if(direction == 3):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North)
				elif(direction == 2):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West)
				elif(direction == 1):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South)
				else:
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East)
				if(connections == 1):
					var nextRoom
					var whichdoor
					if(direction == 3):
						nextRoom = Rooms[CurrentRoom].North[0][0]
						whichdoor = Rooms[CurrentRoom].North[0][2]
					elif(direction == 2):
						nextRoom = Rooms[CurrentRoom].West[0][0]
						whichdoor = Rooms[CurrentRoom].West[0][2]
					elif(direction == 1):
						nextRoom = Rooms[CurrentRoom].South[0][0]
						whichdoor = Rooms[CurrentRoom].South[0][2]
					else:
						nextRoom = Rooms[CurrentRoom].East[0][0]
						whichdoor = Rooms[CurrentRoom].East[0][2]
					if(CurrentRoom != nextRoom):
						Rooms[CurrentRoom].set_process(false)
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(0,-RoomSize.y),0.5,1,2)
						CurrentRoom = nextRoom
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						else:
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						Rooms[CurrentRoom].show()
					else:
						CreateDummyRoom(Rooms[CurrentRoom],Rooms[CurrentRoom].Orientation)
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						else:
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
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
						var roomArray
						if(Rooms[CurrentRoom].Orientation == 3):
							roomArray = Rooms[CurrentRoom].South
						elif(Rooms[CurrentRoom].Orientation == 2):
							roomArray = Rooms[CurrentRoom].West
						elif(Rooms[CurrentRoom].Orientation == 1):
							roomArray = Rooms[CurrentRoom].North
						else:
							roomArray = Rooms[CurrentRoom].East
						for entry in roomArray:
							var roomindex = entry[0]
							var whichdoor = entry[2]
							if(roomindex == CurrentRoom):
								if(whichdoor == 3):
									CreateDummyRoom(Rooms[CurrentRoom],3)
								elif(whichdoor == 2):
									CreateDummyRoom(Rooms[CurrentRoom],0)
								elif(whichdoor == 1):
									CreateDummyRoom(Rooms[CurrentRoom],1)
								else:
									CreateDummyRoom(Rooms[CurrentRoom],2)
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(0,RoomSize.y))
							else:
								if(whichdoor == 3):
									Rooms[roomindex].Orientation = 3
									Rooms[roomindex].set_rotd(0)
								elif(whichdoor == 2):
									Rooms[roomindex].Orientation = 0
									Rooms[roomindex].set_rotd(270)
								elif(whichdoor == 1):
									Rooms[roomindex].Orientation = 1
									Rooms[roomindex].set_rotd(180)
								else:
									Rooms[roomindex].Orientation = 2
									Rooms[roomindex].set_rotd(90)
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(0,RoomSize.y))
						impossible.set_process(true)
					if(PickUp):
						DropBlock()
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,RoomSize.y*0.5),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()
		
		if(event.scancode == KEY_RIGHT or event.scancode == KEY_D):
			var hasdoor
			var direction
			if(Rooms[CurrentRoom].Orientation == 3):
				hasdoor = (type&1)>>0
				direction = 0
			elif(Rooms[CurrentRoom].Orientation == 2):
				hasdoor = (type&2)>>1
				direction = 1
			elif(Rooms[CurrentRoom].Orientation == 1):
				hasdoor = (type&4)>>2
				direction = 2
			else:
				hasdoor = (type&8)>>3
				direction = 3
			if(hasdoor == 1):
				var connections
				if(direction == 3):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].North)
				elif(direction == 2):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].West)
				elif(direction == 1):
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].South)
				else:
					connections = Rooms[CurrentRoom].NumConnections(Rooms[CurrentRoom].East)
				if(connections == 1):
					var nextRoom
					var whichdoor
					if(direction == 3):
						nextRoom = Rooms[CurrentRoom].North[0][0]
						whichdoor = Rooms[CurrentRoom].North[0][2]
					elif(direction == 2):
						nextRoom = Rooms[CurrentRoom].West[0][0]
						whichdoor = Rooms[CurrentRoom].West[0][2]
					elif(direction == 1):
						nextRoom = Rooms[CurrentRoom].South[0][0]
						whichdoor = Rooms[CurrentRoom].South[0][2]
					else:
						nextRoom = Rooms[CurrentRoom].East[0][0]
						whichdoor = Rooms[CurrentRoom].East[0][2]
					if(CurrentRoom != nextRoom):
						Rooms[CurrentRoom].set_process(false)
						tween.interpolate_property(Rooms[CurrentRoom],"transform/pos",Rooms[CurrentRoom].get_pos(),Vector2(-RoomSize.x,0),0.5,1,2)
						CurrentRoom = nextRoom
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						else:
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
						Rooms[CurrentRoom].show()
					else:
						CreateDummyRoom(Rooms[CurrentRoom],Rooms[CurrentRoom].Orientation)
						if(whichdoor == 3):
							Rooms[CurrentRoom].Orientation = 2
							Rooms[CurrentRoom].set_rotd(90)
						elif(whichdoor == 2):
							Rooms[CurrentRoom].Orientation = 3
							Rooms[CurrentRoom].set_rotd(0)
						elif(whichdoor == 1):
							Rooms[CurrentRoom].Orientation = 0
							Rooms[CurrentRoom].set_rotd(270)
						else:
							Rooms[CurrentRoom].Orientation = 1
							Rooms[CurrentRoom].set_rotd(180)
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
						var roomArray
						if(Rooms[CurrentRoom].Orientation == 3):
							roomArray = Rooms[CurrentRoom].East
						elif(Rooms[CurrentRoom].Orientation == 2):
							roomArray = Rooms[CurrentRoom].South
						elif(Rooms[CurrentRoom].Orientation == 1):
							roomArray = Rooms[CurrentRoom].West
						else:
							roomArray = Rooms[CurrentRoom].North
						for entry in roomArray:
							var roomindex = entry[0]
							var whichdoor = entry[2]
							if(roomindex == CurrentRoom):
								if(whichdoor == 3):
									CreateDummyRoom(Rooms[CurrentRoom],2)
								elif(whichdoor == 2):
									CreateDummyRoom(Rooms[CurrentRoom],3)
								elif(whichdoor == 1):
									CreateDummyRoom(Rooms[CurrentRoom],0)
								else:
									CreateDummyRoom(Rooms[CurrentRoom],1)
								impossible.RoomCycle.append(DummyRoom)
								DummyRoom.set_pos(Vector2(RoomSize.x,0))
							else:
								if(whichdoor == 3):
									Rooms[roomindex].Orientation = 2
									Rooms[roomindex].set_rotd(90)
								elif(whichdoor == 2):
									Rooms[roomindex].Orientation = 3
									Rooms[roomindex].set_rotd(0)
								elif(whichdoor == 1):
									Rooms[roomindex].Orientation = 0
									Rooms[roomindex].set_rotd(270)
								else:
									Rooms[roomindex].Orientation = 1
									Rooms[roomindex].set_rotd(180)
								impossible.RoomCycle.append(Rooms[roomindex])
								Rooms[roomindex].set_pos(Vector2(RoomSize.x,0))
						impossible.set_process(true)
					if(PickUp):
						DropBlock()
					tween.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(RoomSize.x*0.5,0),0.25,0,0)
					set_process_input(false)
					set_process(false)
					FalseMove = true
					tween.start()



func CreateDummyRoom(room,orientation):
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
	DummyRoom.Orientation = orientation
	if(orientation == 3):
		DummyRoom.set_rotd(0)
	elif(orientation == 2):
		DummyRoom.set_rotd(90)
	elif(orientation == 1):
		DummyRoom.set_rotd(180)
	else:
		DummyRoom.set_rotd(270)
	
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
			box.Orientation = room.BlocksArray[i][j].Orientation
			if(box.Orientation == 3):
				box.set_rotd(0)
			elif(box.Orientation == 2):
				box.set_rotd(90)
			elif(box.Orientation == 1):
				box.set_rotd(180)
			else:
				box.set_rotd(270)
			box.set_pos(room.BlocksArray[i][j].get_pos())
			DummyRoom.BlocksArray[i].append(box)
			DummyRoom.add_child(box)

func _on_Tween_tween_complete( object, key ):
	
	DummyRoom.hide()
	if(MovedNorth or MovedWest or MovedSouth or MovedEast):
		tween.remove_all()
		for i in range(Rooms.size()):
			if(i != CurrentRoom):
				Rooms[i].hide()
			
		Rooms[CurrentRoom].update()
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.update()
		MovedNorth = false
		MovedWest = false
		MovedSouth = false
		MovedEast = false
		set_process_input(true)
	
	if(FalseMove):
		tween2.interpolate_property(CurrentCamera,"transform/pos",CurrentCamera.get_pos(),Vector2(0,0),0.25,0,1,0.25)
		tween2.start()
		FalseMove = false
	
	if(RotatingMove):
		tween.remove_all()
		set_process(true)
		set_process_input(true)
		Rooms[CurrentRoom].ComputeMiddleBlocks()
		ComputeEdgeBlocks(CurrentRoom)
		
		Rooms[CurrentRoom].update()
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				if(block.get_rotd() >= 360):
					block.set_rotd(block.get_rotd() - 360)
				block.set_z(10)
				block.update()
		if(PickUpBlock != null):
			PickUpBlock.set_z(100)
			if(PickUpBlock.get_rotd() >= 360):
				PickUpBlock.set_rotd(PickUpBlock.get_rotd() - 360)
	
	#TODO(ian): This no longer works!!!!1
	if(DrosteMove):
		tween.remove_all()
		Rooms[CurrentRoom].hide()
		CurrentRoom = DrosteRoom
		Rooms[CurrentRoom].show()
		Rooms[CurrentRoom].set_pos(Vector2(0,0))
		Rooms[CurrentRoom].update()
		Rooms[CurrentRoom].Orientation = DrosteOrient
		Rooms[CurrentRoom].set_rotd((3-DrosteOrient) * 90)
		for roomblocks in Rooms[CurrentRoom].BlocksArray:
			for block in roomblocks:
				block.update()
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
		DrosteOrient = 3
		DrosteBlock = null


func _on_Tween2_tween_complete( object, key ):
	for room in impossible.RoomCycle:
		room.hide()
	impossible.RoomCycle.clear()
	impossible.set_process(false)
	tween2.remove_all()
	set_process_input(true)
	set_process(true)
