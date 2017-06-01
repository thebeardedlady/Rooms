extends Node2D


var Type = 0
var Index = -1
var North = []
var West = []
var South = []
var East = []
var BlocksGrid = []
var BlocksArray = []
var Moving = false
var MovingBlock = null
var RoomColor = Color()
var BlockSize = Vector2()
var BlocksGridSize = Vector2(6,6)
onready var RoomSize = get_node("../").RoomSize
onready var Level = get_node("../")
onready var LevelRooms = get_node("../").Rooms

func _ready():
	set_process(true)

func _draw():
	print(str(Index))
	print("North: " + str(North))
	print("West: " + str(West))
	print("South: " + str(South))
	print("East: " + str(East))
	DrawRoom(Index,Vector2(0,0),RoomSize,RoomColor,0)

func _process(delta):
	if(not Moving):
		for roomblocks in BlocksArray:
			for block in roomblocks:
				if(block.BoundingBox.has_point(get_global_mouse_pos()) and Input.is_action_pressed("select_block")):
					Moving = true
					MovingBlock = block
	else:
		if(Input.is_action_pressed("select_block")):
			var rect = Rect2(0,0,BlocksGridSize.x-0.5,BlocksGridSize.y-0.5)
			var mousepos = get_global_mouse_pos()-(BlockSize*0.5)
			mousepos = mousepos.snapped(BlockSize)
			var temppos = mousepos - BlockSize
			temppos.x /= BlockSize.x
			temppos.y /= BlockSize.y
			if(rect.has_point(temppos)):
				if(BlocksGrid[temppos.x][temppos.y] == null):
					if(MovingBlock.GridP.distance_squared_to(temppos) == 1):
						BlocksGrid[MovingBlock.GridP.x][MovingBlock.GridP.y] = null
						BlocksGrid[temppos.x][temppos.y] = MovingBlock
						MovingBlock.GridP = temppos
						MovingBlock.BoundingBox.pos = mousepos
						MovingBlock.set_pos(mousepos)
						ComputeBlocks()
		else:
			Moving = false
			MovingBlock = null
		update()

func DrawRoom(index,pos,size,color,num):
	
	var bordercolor = color
	bordercolor.r *= 0.75
	bordercolor.g *= 0.75
	bordercolor.b *= 0.75
	
	var borderdim = size
	borderdim.x /= (BlocksGridSize.x+2)
	borderdim.y /= (BlocksGridSize.y+2)
	
	
	draw_rect(Rect2(pos,size),color)
	if(LevelRooms[index].BlocksGrid.size() > 0):
		var rectpos = pos + borderdim
		var rectsize = size-borderdim-borderdim
		draw_line(rectpos,rectpos+Vector2(rectsize.x,0),bordercolor)
		draw_line(rectpos,rectpos+Vector2(0,rectsize.y),bordercolor)
		draw_line(rectpos+Vector2(rectsize.x,0),rectpos+rectsize,bordercolor)
		draw_line(rectpos+Vector2(0,rectsize.y),rectpos+rectsize,bordercolor)
	draw_rect(Rect2(pos,borderdim),bordercolor)
	draw_rect(Rect2(pos+size-borderdim,borderdim),bordercolor)
	draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,borderdim.x,borderdim.y),bordercolor)
	draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,borderdim.y),bordercolor)
	
	
	var linegirth = borderdim
	var linelength = (size + linegirth) * 0.5
	var type = LevelRooms[index].Type
	var hasexit = false
	
	if(((type & 8)>>3) == 1):
		var numconnections = NumConnections(LevelRooms[index].North)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(NumConnections(LevelRooms[LevelRooms[index].North[0][0]].South) == 1):
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
		var numconnections = NumConnections(LevelRooms[index].West)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(NumConnections(LevelRooms[LevelRooms[index].West[0][0]].East) == 1):
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
		var numconnections = NumConnections(LevelRooms[index].South)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(NumConnections(LevelRooms[LevelRooms[index].South[0][0]].North) == 1):
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
		var numconnections = NumConnections(LevelRooms[index].East)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(NumConnections(LevelRooms[LevelRooms[index].East[0][0]].West) == 1):
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
	
	
	if(num > 0):
		for roomblocks in LevelRooms[index].BlocksArray:
			for block in roomblocks:
				var bpos = Vector2()
				bpos.x = (block.GridP.x+1)*borderdim.x + pos.x
				bpos.y = (block.GridP.y+1)*borderdim.y + pos.y
				var markcolor
				markcolor = LevelRooms[block.RoomIndex].RoomColor
				markcolor.r *= 0.75
				markcolor.g *= 0.75
				markcolor.b *= 0.75
				if(block == MovingBlock and Moving == true):
					markcolor.r *= 0.75
					markcolor.g *= 0.75
					markcolor.b *= 0.75
				DrawRoom(block.RoomIndex,bpos,borderdim,markcolor,num-1)
				draw_line(bpos,bpos+Vector2(0,borderdim.y),Color(0,0,0))
				draw_line(bpos,bpos+Vector2(borderdim.x,0),Color(0,0,0))
				draw_line(bpos+Vector2(borderdim.x,0),bpos+borderdim,Color(0,0,0))
				draw_line(bpos+Vector2(0,borderdim.y),bpos+borderdim,Color(0,0,0))


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
	BlockSize.x = RoomSize.x/(BlocksGridSize.x+2.0)
	BlockSize.y = RoomSize.y/(BlocksGridSize.y+2.0)
	
	for x in range(BlocksGridSize.x):
		BlocksGrid.append([])
		for y in range(BlocksGridSize.y):
			BlocksGrid[x].append(null)
	
	
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
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.x = (pos.x + 1) * BlockSize.x
		BlocksGrid[pos.x][pos.y].BoundingBox.pos.y = (pos.y + 1) * BlockSize.y
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
	
	ComputeBlocks()


func ComputeBlocks():
	var rect = Rect2(0,0,BlocksGridSize.x-0.5,BlocksGridSize.y-0.5)
	
	for roomblocks in BlocksArray:
		
		var roomindex = roomblocks[0].RoomIndex
		
		for i in range(LevelRooms[roomindex].North.size()-1,-1,-1):
			if(LevelRooms[roomindex].North[i][1] == Index):
				LevelRooms[roomindex].North.remove(i)
		
		for i in range(LevelRooms[roomindex].West.size()-1,-1,-1):
			if(LevelRooms[roomindex].West[i][1] == Index):
				LevelRooms[roomindex].West.remove(i)
		
		for i in range(LevelRooms[roomindex].South.size()-1,-1,-1):
			if(LevelRooms[roomindex].South[i][1] == Index):
				LevelRooms[roomindex].South.remove(i)
		
		for i in range(LevelRooms[roomindex].East.size()-1,-1,-1):
			if(LevelRooms[roomindex].East[i][1] == Index):
				LevelRooms[roomindex].East.remove(i)
		
		var hasNorth = (LevelRooms[roomindex].Type&8)>>3
		var hasWest = (LevelRooms[roomindex].Type&4)>>2
		var hasSouth = (LevelRooms[roomindex].Type&2)>>1
		var hasEast = (LevelRooms[roomindex].Type&1)>>0
		
		
		for block in roomblocks:
			if(hasNorth == 1):
				var point = block.GridP + Vector2(0,-1)
				if(rect.has_point(point)):
					if(BlocksGrid[point.x][point.y] != null):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (LevelRooms[index].Type&2)>>1
						if(hasdoor == 1):
							LevelRooms[roomindex].North.append([index,Index])
			
			if(hasWest == 1):
				var point = block.GridP + Vector2(-1,0)
				if(rect.has_point(point)):
					if(BlocksGrid[point.x][point.y] != null):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (LevelRooms[index].Type&1)>>0
						if(hasdoor == 1):
							LevelRooms[roomindex].West.append([index,Index])
			
			if(hasSouth == 1):
				var point = block.GridP + Vector2(0,1)
				if(rect.has_point(point)):
					if(BlocksGrid[point.x][point.y] != null):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (LevelRooms[index].Type&8)>>3
						if(hasdoor == 1):
							LevelRooms[roomindex].South.append([index,Index])
			
			if(hasEast == 1):
				var point = block.GridP + Vector2(1,0)
				if(rect.has_point(point)):
					if(BlocksGrid[point.x][point.y] != null):
						var index = BlocksGrid[point.x][point.y].RoomIndex
						var hasdoor = (LevelRooms[index].Type&4)>>2
						if(hasdoor == 1):
							LevelRooms[roomindex].East.append([index,Index])