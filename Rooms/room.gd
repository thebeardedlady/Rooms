extends Node2D


var Type = 0
var Index = -1
var North = []
var West = []
var South = []
var East = []
var BlocksGrid = []
var BlocksArray = []
var RoomColor = Color()
var BlockSize = Vector2()
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
	DrawRoom(Index,Vector2(0,0),RoomSize,RoomColor)

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
				if(NumConnections(Rooms[Rooms[index].North[0][0]].South) == 1):
					linecolor = Color(0,0,0)
					hasexit = true
				else:
					linecolor = Color(0.5,0.5,0.5)
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
				if(NumConnections(Rooms[Rooms[index].West[0][0]].East) == 1):
					linecolor = Color(0,0,0)
					hasexit = true
				else:
					linecolor = Color(0.5,0.5,0.5)
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
				if(NumConnections(Rooms[Rooms[index].South[0][0]].North) == 1):
					linecolor = Color(0,0,0)
					hasexit = true
				else:
					linecolor = Color(0.5,0.5,0.5)
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
				if(NumConnections(Rooms[Rooms[index].East[0][0]].West) == 1):
					linecolor = Color(0,0,0)
					hasexit = true
				else:
					linecolor = Color(0.5,0.5,0.5)
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
		var temp = door[0][0]
		for i in range(door.size()):
			if(door[i][0] != temp):
				return 2
		return 1
	

func InitBlocks(string):
	
	
	var blockstrings = string.split("/",false)
	var i = 0
	for text in blockstrings:
		var split = text.split(",",false)
		var roomindex = split[0].to_int()
		var pos = Vector2(split[1].to_int(),split[2].to_int()) + Vector2(1,1)
		BlocksGrid[pos.x][pos.y] = load("res://block.tscn").instance()
		BlocksGrid[pos.x][pos.y].RoomIndex = roomindex
		BlocksGrid[pos.x][pos.y].Index = i
		BlocksGrid[pos.x][pos.y].GridP = pos
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.x = pos.x * BlockSize.x
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.y = pos.y * BlockSize.y
		BlocksGrid[pos.x][pos.y].set_pos(BlocksGrid[pos.x][pos.y].BoundingBox.pos)
		BlocksGrid[pos.x][pos.y].BoundingBox.size = BlockSize
		var index = -1
		for i in range(BlocksArray.size()):
			if(BlocksArray[i][0].RoomIndex == BlocksGrid[pos.x][pos.y].RoomIndex):
				index = i
		if(index == -1):
			BlocksArray.append([BlocksGrid[pos.x][pos.y]])
		else:
			BlocksArray[index].append(BlocksGrid[pos.x][pos.y])
		add_child(BlocksGrid[pos.x][pos.y])
		i += 1
	
	ComputeSingleBlock()



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


func ComputeBlocks():
	ComputeSingleBlock()
	if(NumConnections(North) == 1):
		Rooms[North[0][0]].ComputeSingleBlock()
	if(NumConnections(West) == 1):
		Rooms[West[0][0]].ComputeSingleBlock()
	if(NumConnections(South) == 1):
		Rooms[South[0][0]].ComputeSingleBlock()
	if(NumConnections(East) == 1):
		Rooms[East[0][0]].ComputeSingleBlock()



func ComputeSingleBlock():
	var rect = Rect2(0,0,BlocksGridSize.x-0.5,BlocksGridSize.y-0.5)
	
	for roomblocks in BlocksArray:
		
		
		
		
		var roomindex = roomblocks[0].RoomIndex
		EraseConnections(roomindex,Index)
		EraseConnections(roomindex,-Index)
		
		if(Index == 6 and roomindex == 14):
			var temp = 5
		
		if(roomindex == 9):
			var temp = 0
		
		
		var hasNorth = (Rooms[roomindex].Type&8)>>3
		var hasWest = (Rooms[roomindex].Type&4)>>2
		var hasSouth = (Rooms[roomindex].Type&2)>>1
		var hasEast = (Rooms[roomindex].Type&1)>>0
		
		
		for block in roomblocks:
			if(hasNorth == 1):
				var point = block.GridP + Vector2(0,-1)
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (Rooms[index].Type&2)>>1
						if(hasdoor == 1):
							Rooms[roomindex].North.append([index,Index])
				else:
					#EraseNorth(roomindex,-Index)
					if(NumConnections(North) == 1):
						var northBlock = Rooms[North[0][0]].BlocksGrid[point.x][BlocksGridSize.y-1]
						if(typeof(northBlock) == typeof(block)):
							var hasdoor = (Rooms[northBlock.RoomIndex].Type&2)>>1
							if(hasdoor == 1):
								Rooms[roomindex].North.append([northBlock.RoomIndex,-Index])
			
			if(hasWest == 1):
				var point = block.GridP + Vector2(-1,0)
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (Rooms[index].Type&1)>>0
						if(hasdoor == 1):
							Rooms[roomindex].West.append([index,Index])
				else:
					#EraseWest(roomindex,-Index)
					if(NumConnections(West) == 1):
						var westBlock = Rooms[West[0][0]].BlocksGrid[BlocksGridSize.x-1][point.y]
						if(typeof(westBlock) == typeof(block)):
							var hasdoor = (Rooms[westBlock.RoomIndex].Type&1)>>0
							if(hasdoor == 1):
								Rooms[roomindex].West.append([westBlock.RoomIndex,-Index])
			
			if(hasSouth == 1):
				var point = block.GridP + Vector2(0,1)
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (Rooms[index].Type&8)>>3
						if(hasdoor == 1):
							Rooms[roomindex].South.append([index,Index])
				else:
					#EraseSouth(roomindex,-Index)
					if(NumConnections(South) == 1):
						var southBlock = Rooms[South[0][0]].BlocksGrid[point.x][0]
						if(typeof(southBlock) == typeof(block)):
							var hasdoor = (Rooms[southBlock.RoomIndex].Type&8)>>3
							if(hasdoor == 1):
								Rooms[roomindex].South.append([southBlock.RoomIndex,-Index])
			
			if(hasEast == 1):
				var point = block.GridP + Vector2(1,0)
				if(rect.has_point(point)):
					if(typeof(BlocksGrid[point.x][point.y]) == typeof(block)):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (Rooms[index].Type&4)>>2
						if(hasdoor == 1):
							Rooms[roomindex].East.append([index,Index])
				else:
					#EraseEast(roomindex,-Index)
					if(NumConnections(East) == 1):
						var eastBlock = Rooms[East[0][0]].BlocksGrid[0][point.y]
						if(typeof(eastBlock) == typeof(block)):
							var hasdoor = (Rooms[eastBlock.RoomIndex].Type&4)>>2
							if(hasdoor == 1):
								Rooms[roomindex].East.append([eastBlock.RoomIndex,-Index])