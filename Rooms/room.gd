extends Node2D


var Type = 0
var Index = -1
var Orientation = 3
var North = []
var West = []
var South = []
var East = []
var BlocksGrid = []
var BlocksArray = []
var RoomColor = Color()
var BlockSize = Vector2()
var Offset
onready var BlocksGridSize = get_node("../").BlocksGridSize 
onready var RoomSize = get_node("../").RoomSize
onready var Level = get_node("../")
onready var Rooms = get_node("../").Rooms


func _ready():
	BlockSize.x = RoomSize.x/BlocksGridSize.x
	BlockSize.y = RoomSize.y/BlocksGridSize.y
	
	for x in range(BlocksGridSize.x):
		BlocksGrid.append([])
		for y in range(BlocksGridSize.y):
			BlocksGrid[x].append(null)
	
	
	BlocksGrid[0][0] = 0
	BlocksGrid[BlocksGridSize.x-1][0] = 0
	BlocksGrid[0][BlocksGridSize.y-1] = 0
	BlocksGrid[BlocksGridSize.x-1][BlocksGridSize.y-1] = 0
	
	if((Type&8)>>3 != 1):
		for x in range(BlocksGridSize.x):
			BlocksGrid[x][0] = 0
	if((Type&4)>>2 != 1):
		for y in range(BlocksGridSize.y):
			BlocksGrid[0][y] = 0
	if((Type&2)>>1 != 1):
		for x in range(BlocksGridSize.x):
			BlocksGrid[x][BlocksGridSize.y-1] = 0
	if((Type&1)>>0 != 1):
		for y in range(BlocksGridSize.y):
			BlocksGrid[BlocksGridSize.x-1][y] = 0

func _draw():
	DrawRoom(Index,RoomSize * -0.5,RoomSize,RoomColor)

func _process(delta):
	update()


func DrawRoom(index,pos,size,color):
	
	var bordercolor = color
	bordercolor.r *= 0.5
	bordercolor.g *= 0.5
	bordercolor.b *= 0.5
	
	var borderdim = size
	borderdim.x /= BlocksGridSize.x
	borderdim.y /= BlocksGridSize.y
	
	var move = RoomSize * 0.5
	
	draw_rect(Rect2(pos,size),color)
	draw_rect(Rect2(pos,borderdim),bordercolor)
	draw_rect(Rect2(pos+size-borderdim,borderdim),bordercolor)
	draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,borderdim.x,borderdim.y),bordercolor)
	draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,borderdim.y),bordercolor)
	
	
	var linegirth = borderdim
	var linelength = (size + linegirth) * 0.5
	var type = Rooms[index].Type
	var hasexit = false
	
	if(((type & 8)>>3) == 1):
		var numconnections = NumConnections(Rooms[index].North)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				linecolor = Color(0,0,0)
				hasexit = true
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.x += (size.x - linegirth.x) * 0.5
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,size.x,borderdim.y),bordercolor)
	
	if(((type & 4)>>2) == 1):
		var numconnections = NumConnections(Rooms[index].West)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				linecolor = Color(0,0,0)
				hasexit = true
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.y += (size.y - linegirth.y) * 0.5
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(((type & 2)>>1) == 1):
		var numconnections = NumConnections(Rooms[index].South)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				linecolor = Color(0,0,0)
				hasexit = true
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,size.x,borderdim.y),bordercolor)
	
	if(((type & 1)>>0) == 1):
		var numconnections = NumConnections(Rooms[index].East)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				linecolor = Color(0,0,0)
				hasexit = true
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(hasexit):
		draw_rect(Rect2(pos+(size-linegirth)*0.5,linegirth),Color(0,0,0))



func NumConnections(door):
	if(door.size() == 0):
		return 0
	else:
		var temp = [door[0][0],door[0][2]]
		for i in range(door.size()):
			if(door[i][0] != temp[0]):
				return 2
			else:
				if(door[i][2] != temp[1]):
					return 2
		return 1
	

func InitBlocks(string):
	
	
	var blockstrings = string.split("/",false)
	var i = 0
	for text in blockstrings:
		var split = text.split(",",false)
		var roomindex = split[0].to_int()
		var pos = Vector2(split[1].to_int(),split[2].to_int())
		BlocksGrid[pos.x][pos.y] = load("res://block.tscn").instance()
		BlocksGrid[pos.x][pos.y].RoomIndex = roomindex
		BlocksGrid[pos.x][pos.y].Index = i
		BlocksGrid[pos.x][pos.y].GridP = pos
		#TODO(ian): set up orientation here
		BlocksGrid[pos.x][pos.y].Orientation = split[3].to_int()
		if(BlocksGrid[pos.x][pos.y].Orientation == 3):
			BlocksGrid[pos.x][pos.y].set_rotd(0)
		elif(BlocksGrid[pos.x][pos.y].Orientation == 2):
			BlocksGrid[pos.x][pos.y].set_rotd(90)
		elif(BlocksGrid[pos.x][pos.y].Orientation == 1):
			BlocksGrid[pos.x][pos.y].set_rotd(180)
		else:
			BlocksGrid[pos.x][pos.y].set_rotd(270)
		#NOTE(ian): Maybe don't need BoundingBox anymore
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.x = (pos.x - 0.5 * (BlocksGridSize.x - 1)) * BlockSize.x
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.y = (pos.y - 0.5 * (BlocksGridSize.y - 1)) * BlockSize.y
		BlocksGrid[pos.x][pos.y].set_pos(BlocksGrid[pos.x][pos.y].BoundingBox.pos)
		BlocksGrid[pos.x][pos.y].set_z(10)
		BlocksGrid[pos.x][pos.y].BoundingBox.size = BlockSize
		var index = -1
		for j in range(BlocksArray.size()):
			if(BlocksArray[j][0].RoomIndex == BlocksGrid[pos.x][pos.y].RoomIndex):
				index = j
		if(index == -1):
			BlocksArray.append([BlocksGrid[pos.x][pos.y]])
		else:
			BlocksArray[index].append(BlocksGrid[pos.x][pos.y])
		add_child(BlocksGrid[pos.x][pos.y])
		i += 1
		
		#TODO(ian): Maybe we don't need this call
		ComputeMiddleBlocks()



func EraseConnections(blockindex,roomindex):
	EraseNorth(blockindex,roomindex)
	EraseWest(blockindex,roomindex)
	EraseSouth(blockindex,roomindex)
	EraseEast(blockindex,roomindex)



func EraseNorth(blockindex,roomindex):
	for i in range(Rooms[blockindex].North.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].North[i][1]
		if(deletedindex == roomindex):
			Rooms[blockindex].North.remove(i)

func EraseWest(blockindex,roomindex):
	for i in range(Rooms[blockindex].West.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].West[i][1]
		if(deletedindex == roomindex):
			Rooms[blockindex].West.remove(i)

func EraseSouth(blockindex,roomindex):
	for i in range(Rooms[blockindex].South.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].South[i][1]
		if(deletedindex == roomindex):
			Rooms[blockindex].South.remove(i)

func EraseEast(blockindex,roomindex):
	for i in range(Rooms[blockindex].East.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].East[i][1]
		if(deletedindex == roomindex):
			Rooms[blockindex].East.remove(i)

func EraseEdgeNorth(blockindex,roomindex):
	var value = null
	for i in range(Rooms[blockindex].North.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].North[i][1]
		if(deletedindex == roomindex):
			if(Rooms[blockindex].North.count(Rooms[blockindex].North[i]) < 2):
				Rooms[blockindex].North.remove(i)
			else:
				value = Rooms[blockindex].North[i]
	if(value != null):
		Rooms[blockindex].North.erase(value)
	

func EraseEdgeWest(blockindex,roomindex):
	var value = null
	for i in range(Rooms[blockindex].West.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].West[i][1]
		if(deletedindex == roomindex):
			if(Rooms[blockindex].West.count(Rooms[blockindex].West[i]) < 2):
				Rooms[blockindex].West.remove(i)
			else:
				value = Rooms[blockindex].West[i]
	if(value != null):
		Rooms[blockindex].West.erase(value)

func EraseEdgeSouth(blockindex,roomindex):
	var value = null
	for i in range(Rooms[blockindex].South.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].South[i][1]
		if(deletedindex == roomindex):
			if(Rooms[blockindex].South.count(Rooms[blockindex].South[i]) < 2):
				Rooms[blockindex].South.remove(i)
			else:
				value = Rooms[blockindex].South[i]
	if(value != null):
		Rooms[blockindex].South.erase(value)

func EraseEdgeEast(blockindex,roomindex):
	var value = null
	for i in range(Rooms[blockindex].East.size()-1,-1,-1):
		var deletedindex = Rooms[blockindex].East[i][1]
		if(deletedindex == roomindex):
			if(Rooms[blockindex].East.count(Rooms[blockindex].East[i]) < 2):
				Rooms[blockindex].East.remove(i)
			else:
				value = Rooms[blockindex].East[i]
	if(value != null):
		Rooms[blockindex].East.erase(value)


func OtherConnected(way,roomindex):
	for entry in way:
		if(entry[0] != roomindex):
			return true
	return false

func ComputeEdgeBlocks():
	for roomblocks in BlocksArray:
		var roomindex = roomblocks[0].RoomIndex
		
		var connectedNorth = (NumConnections(North)>0)
		var connectedWest = (NumConnections(West)>0)
		var connectedSouth = (NumConnections(South)>0)
		var connectedEast = (NumConnections(East)>0)
		
		
		var roomtype = Rooms[roomindex].Type
		var addNorth = []
		var addWest = []
		var addSouth = []
		var addEast = []
		
		for block in roomblocks:
			if(block.GridP.y == 0):
				if(connectedNorth):
					var pointing
					var roomDoor
					if(block.Orientation == 3):
						pointing = (roomtype&8)>>3
						roomDoor = 3
					elif(block.Orientation == 2):
						pointing = (roomtype&1)>>0
						roomDoor = 0
					elif(block.Orientation == 1):
						pointing = (roomtype&2)>>1
						roomDoor = 1
					else:
						pointing = (roomtype&4)>>2
						roomDoor = 2
					if(pointing == 1):
						var connectedRooms = []
						var roomDoors = []
						for entry in North:
							if(not connectedRooms.has(entry[0])):
								connectedRooms.append(entry[0])
								roomDoors.append(entry[2])
						for i in range(connectedRooms.size()):
							var northBlock
							if(roomDoors[i] == 3):
								northBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x - block.GridP.x - 1][0]
							elif(roomDoors[i] == 2):
								northBlock = Rooms[connectedRooms[i]].BlocksGrid[0][block.GridP.x]
							elif(roomDoors[i] == 1):
								northBlock = Rooms[connectedRooms[i]].BlocksGrid[block.GridP.x][BlocksGridSize.y-1]
							else:
								northBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x - 1][BlocksGridSize.x - block.GridP.x - 1]
							if(typeof(northBlock) == typeof(block)):
								var index = northBlock.RoomIndex
								var orientation = northBlock.Orientation
								var hasdoor
								var whichdoor
								if(roomDoors[i] == 3): #dway is 1 south
									if(orientation == 3): 
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 2):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 1):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									else:
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
								elif(roomDoors[i] == 2): #dway is 0 East
									if(orientation == 3):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 2):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 1):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									else:
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
								elif(roomDoors[i] == 1): #dway is 3 North
									if(orientation == 3):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 2):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 1):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									else:
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
								else: #dway is 2 West
									if(orientation == 3):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 2):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 1):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									else:
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
								if(hasdoor == 1):
									if(roomDoor == 3):
										addNorth.append([index,-Index,whichdoor])
									elif(roomDoor == 2):
										addWest.append([index,-Index,whichdoor])
									elif(roomDoor == 1):
										addSouth.append([index,-Index,whichdoor])
									else:
										addEast.append([index,-Index,whichdoor])
			
			
			if(block.GridP.x == 0):
				if(connectedWest):
					var pointing
					var roomDoor
					if(block.Orientation == 3):
						pointing = (roomtype&4)>>2
						roomDoor = 2
					elif(block.Orientation == 2):
						pointing = (roomtype&8)>>3
						roomDoor = 3
					elif(block.Orientation == 1):
						pointing = (roomtype&1)>>0
						roomDoor = 0
					else:
						pointing = (roomtype&2)>>1
						roomDoor = 1
					if(pointing == 1):
						var connectedRooms = []
						var roomDoors = []
						for entry in West:
							if(not connectedRooms.has(entry[0])):
								connectedRooms.append(entry[0])
								roomDoors.append(entry[2])
						for i in range(connectedRooms.size()):
							var westBlock
							if(roomDoors[i] == 3):
								westBlock = Rooms[connectedRooms[i]].BlocksGrid[block.GridP.y][0]
							elif(roomDoors[i] == 2):
								westBlock = Rooms[connectedRooms[i]].BlocksGrid[0][BlocksGridSize.y - block.GridP.y - 1]
							elif(roomDoors[i] == 1):
								westBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.y - block.GridP.y - 1][BlocksGridSize.y-1]
							else:
								westBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x-1][block.GridP.y]
							if(typeof(westBlock) == typeof(block)):
								var index = westBlock.RoomIndex
								var orientation = westBlock.Orientation
								var hasdoor
								var whichdoor
								if(roomDoors[i] == 3): #dway is 1 south
									if(orientation == 3): 
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 2):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 1):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									else:
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
								elif(roomDoors[i] == 2): #dway is 0 East
									if(orientation == 3):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 2):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 1):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									else:
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
								elif(roomDoors[i] == 1): #dway is 3 North
									if(orientation == 3):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 2):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 1):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									else:
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
								else: #dway is 2 West
									if(orientation == 3):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 2):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 1):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									else:
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
								if(hasdoor == 1):
									if(roomDoor == 3):
										addNorth.append([index,-Index,whichdoor])
									elif(roomDoor == 2):
										addWest.append([index,-Index,whichdoor])
									elif(roomDoor == 1):
										addSouth.append([index,-Index,whichdoor])
									else:
										addEast.append([index,-Index,whichdoor])
			
			if(block.GridP.y == BlocksGridSize.y-1):
				if(connectedSouth):
					var pointing
					var roomDoor
					if(block.Orientation == 3):
						pointing = (roomtype&2)>>1
						roomDoor = 1
					elif(block.Orientation == 2):
						pointing = (roomtype&4)>>2
						roomDoor = 2
					elif(block.Orientation == 1):
						pointing = (roomtype&8)>>3
						roomDoor = 3
					else:
						pointing = (roomtype&1)>>0
						roomDoor = 0
					if(pointing == 1):
						var connectedRooms = []
						var roomDoors = []
						for entry in South:
							if(not connectedRooms.has(entry[0])):
								connectedRooms.append(entry[0])
								roomDoors.append(entry[2])
						for i in range(connectedRooms.size()):
							var southBlock
							if(roomDoors[i] == 3):
								southBlock = Rooms[connectedRooms[i]].BlocksGrid[block.GridP.x][0]
							elif(roomDoors[i] == 2):
								southBlock = Rooms[connectedRooms[i]].BlocksGrid[0][BlocksGridSize.x - block.GridP.x - 1]
							elif(roomDoors[i] == 1):
								southBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x - block.GridP.x - 1][BlocksGridSize.y - 1]
							else:
								southBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x - 1][block.GridP.x]
							if(typeof(southBlock) == typeof(block)):
								var index = southBlock.RoomIndex
								var orientation = southBlock.Orientation
								var hasdoor
								var whichdoor
								if(roomDoors[i] == 3): #dway is 1 south
									if(orientation == 3): 
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 2):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 1):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									else:
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
								elif(roomDoors[i] == 2): #dway is 0 East
									if(orientation == 3):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 2):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 1):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									else:
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
								elif(roomDoors[i] == 1): #dway is 3 North
									if(orientation == 3):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 2):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 1):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									else:
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
								else: #dway is 2 West
									if(orientation == 3):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 2):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 1):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									else:
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
								if(hasdoor == 1):
									if(roomDoor == 3):
										addNorth.append([index,-Index,whichdoor])
									elif(roomDoor == 2):
										addWest.append([index,-Index,whichdoor])
									elif(roomDoor == 1):
										addSouth.append([index,-Index,whichdoor])
									else:
										addEast.append([index,-Index,whichdoor])
			
			if(block.GridP.x == BlocksGridSize.x-1):
				if(connectedEast):
					var pointing
					var roomDoor
					if(block.Orientation == 3):
						pointing = (roomtype&1)>>0
						roomDoor = 0
					elif(block.Orientation == 2):
						pointing = (roomtype&2)>>1
						roomDoor = 1
					elif(block.Orientation == 1):
						pointing = (roomtype&4)>>2
						roomDoor = 2
					else:
						pointing = (roomtype&8)>>3
						roomDoor = 3
					if(pointing == 1):
						var connectedRooms = []
						var roomDoors = []
						for entry in East:
							if(not connectedRooms.has(entry[0])):
								connectedRooms.append(entry[0])
								roomDoors.append(entry[2])
						for i in range(connectedRooms.size()):
							var eastBlock
							if(roomDoors[i] == 3):
								eastBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.y - block.GridP.y - 1][0]
							elif(roomDoors[i] == 2):
								eastBlock = Rooms[connectedRooms[i]].BlocksGrid[0][block.GridP.y]
							elif(roomDoors[i] == 1):
								eastBlock = Rooms[connectedRooms[i]].BlocksGrid[block.GridP.y][BlocksGridSize.y-1]
							else:
								eastBlock = Rooms[connectedRooms[i]].BlocksGrid[BlocksGridSize.x-1][BlocksGridSize.y - block.GridP.y - 1]
							if(typeof(eastBlock) == typeof(block)):
								var index = eastBlock.RoomIndex
								var orientation = eastBlock.Orientation
								var hasdoor
								var whichdoor
								if(roomDoors[i] == 3): #dway is 1 south
									if(orientation == 3): 
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 2):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 1):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									else:
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
								elif(roomDoors[i] == 2): #dway is 0 East
									if(orientation == 3):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 2):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									elif(orientation == 1):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									else:
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
								elif(roomDoors[i] == 1): #dway is 3 North
									if(orientation == 3):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 2):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									elif(orientation == 1):
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
									else:
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
								else: #dway is 2 West
									if(orientation == 3):
										#East
										hasdoor = (Rooms[index].Type&1)>>0
										whichdoor = 0
									elif(orientation == 2):
										#South
										hasdoor = (Rooms[index].Type&2)>>1
										whichdoor = 1
									elif(orientation == 1):
										#West
										hasdoor = (Rooms[index].Type&4)>>2
										whichdoor = 2
									else:
										#North
										hasdoor = (Rooms[index].Type&8)>>3
										whichdoor = 3
								if(hasdoor == 1):
									if(roomDoor == 3):
										addNorth.append([index,-Index,whichdoor])
									elif(roomDoor == 2):
										addWest.append([index,-Index,whichdoor])
									elif(roomDoor == 1):
										addSouth.append([index,-Index,whichdoor])
									else:
										addEast.append([index,-Index,whichdoor])
		
		EraseConnections(roomindex,-Index)
		for entry in addNorth:
			Rooms[roomindex].North.append(entry)
		for entry in addWest:
			Rooms[roomindex].West.append(entry)
		for entry in addSouth:
			Rooms[roomindex].South.append(entry)
		for entry in addEast:
			Rooms[roomindex].East.append(entry)



func ComputeMiddleBlocks():
	var rect = Rect2(0,0,BlocksGridSize.x-0.5,BlocksGridSize.y-0.5)
	
	for roomblocks in BlocksArray:
		var roomindex = roomblocks[0].RoomIndex
		EraseConnections(roomindex,Index)
		
		
		var hasNorth = (Rooms[roomindex].Type&8)>>3
		var hasWest = (Rooms[roomindex].Type&4)>>2
		var hasSouth = (Rooms[roomindex].Type&2)>>1
		var hasEast = (Rooms[roomindex].Type&1)>>0
		
		
		for block in roomblocks:
			if(hasNorth == 1):
				var direction
				var dway
				if(block.Orientation == 3):
					direction = Vector2(0,-1)
					dway = 3
				elif(block.Orientation == 2):
					direction = Vector2(-1,0)
					dway = 2
				elif(block.Orientation == 1):
					direction = Vector2(0,1)
					dway = 1
				else:
					direction = Vector2(1,0)
					dway = 0
				var point = block.GridP + direction
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var orientation = BlocksGrid[point.x][point.y].Orientation
						var hasdoor
						var whichdoor
						if(dway == 3):
							if(orientation == 3):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 2):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 1):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							else:
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
						elif(dway == 2):
							if(orientation == 3):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 2):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 1):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							else:
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
						elif(dway == 1):
							if(orientation == 3):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 2):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 1):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							else:
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
						else:
							if(orientation == 3):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 2):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 1):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							else:
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
						if(hasdoor == 1):
							Rooms[roomindex].North.append([index,Index,whichdoor])
			
			if(hasWest == 1):
				var direction
				var dway
				if(block.Orientation == 3):
					direction = Vector2(-1,0)
					dway = 2
				elif(block.Orientation == 2):
					direction = Vector2(0,1)
					dway = 1
				elif(block.Orientation == 1):
					direction = Vector2(1,0)
					dway = 0
				else:
					direction = Vector2(0,-1)
					dway = 3
				var point = block.GridP + direction
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var orientation = BlocksGrid[point.x][point.y].Orientation
						var hasdoor
						var whichdoor
						if(dway == 3):
							if(orientation == 3):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 2):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 1):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							else:
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
						elif(dway == 2):
							if(orientation == 3):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 2):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 1):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							else:
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
						elif(dway == 1):
							if(orientation == 3):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 2):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 1):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							else:
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
						else:
							if(orientation == 3):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 2):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 1):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							else:
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
						if(hasdoor == 1):
							Rooms[roomindex].West.append([index,Index,whichdoor])
			
			if(hasSouth == 1):
				var direction
				var dway
				if(block.Orientation == 3):
					direction = Vector2(0,1)
					dway = 1
				elif(block.Orientation == 2):
					direction = Vector2(1,0)
					dway = 0
				elif(block.Orientation == 1):
					direction = Vector2(0,-1)
					dway = 3
				else:
					direction = Vector2(-1,0)
					dway = 2
				var point = block.GridP + direction
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var orientation = BlocksGrid[point.x][point.y].Orientation
						var hasdoor
						var whichdoor
						if(dway == 3):
							if(orientation == 3):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 2):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 1):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							else:
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
						elif(dway == 2):
							if(orientation == 3):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 2):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 1):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							else:
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
						elif(dway == 1):
							if(orientation == 3):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 2):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 1):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							else:
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
						else:
							if(orientation == 3):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 2):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 1):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							else:
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
						if(hasdoor == 1):
							Rooms[roomindex].South.append([index,Index,whichdoor])
			
			if(hasEast == 1):
				var direction
				var dway
				if(block.Orientation == 3):
					direction = Vector2(1,0)
					dway = 0
				elif(block.Orientation == 2):
					direction = Vector2(0,-1)
					dway = 3
				elif(block.Orientation == 1):
					direction = Vector2(-1,0)
					dway = 2
				else:
					direction = Vector2(0,1)
					dway = 1
				var point = block.GridP + direction
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var orientation = BlocksGrid[point.x][point.y].Orientation
						var hasdoor
						var whichdoor
						if(dway == 3):
							if(orientation == 3):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 2):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 1):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							else:
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
						elif(dway == 2):
							if(orientation == 3):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 2):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							elif(orientation == 1):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							else:
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
						elif(dway == 1):
							if(orientation == 3):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 2):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							elif(orientation == 1):
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
							else:
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
						else:
							if(orientation == 3):
								#West
								hasdoor = (Rooms[index].Type&4)>>2
								whichdoor = 2
							elif(orientation == 2):
								#North
								hasdoor = (Rooms[index].Type&8)>>3
								whichdoor = 3
							elif(orientation == 1):
								#East
								hasdoor = (Rooms[index].Type&1)>>0
								whichdoor = 0
							else:
								#South
								hasdoor = (Rooms[index].Type&2)>>1
								whichdoor = 1
						if(hasdoor == 1):
							Rooms[roomindex].East.append([index,Index,whichdoor])