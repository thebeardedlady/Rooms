extends Node2D


var Index = 0
export var RoomIndex = -1
export var GridP = Vector2()
export var BoundingBox = Rect2()
onready var PresentRoom = get_node("../")
onready var LevelRooms = get_node("../../").Rooms

func _ready():
	pass

func _process(delta):
	update()

func _draw():
	DrawRoom(RoomIndex,Vector2(0,0),BoundingBox.size,LevelRooms[RoomIndex].RoomColor,1)

func DrawRoom(index,pos,size,color,num):
	
	var bordercolor = color
	bordercolor.r *= 0.75
	bordercolor.g *= 0.75
	bordercolor.b *= 0.75
	
	var borderdim = size
	borderdim.x /= (PresentRoom.BlocksGridSize.x+2)
	borderdim.y /= (PresentRoom.BlocksGridSize.y+2)
	
	
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
		var numconnections = PresentRoom.NumConnections(LevelRooms[index].North)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(PresentRoom.NumConnections(LevelRooms[LevelRooms[index].North[0][0]].South) == 1):
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
		var numconnections = PresentRoom.NumConnections(LevelRooms[index].West)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(PresentRoom.NumConnections(LevelRooms[LevelRooms[index].West[0][0]].East) == 1):
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
		var numconnections = PresentRoom.NumConnections(LevelRooms[index].South)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(PresentRoom.NumConnections(LevelRooms[LevelRooms[index].South[0][0]].North) == 1):
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
		var numconnections = PresentRoom.NumConnections(LevelRooms[index].East)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				if(PresentRoom.NumConnections(LevelRooms[LevelRooms[index].East[0][0]].West) == 1):
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
	
	draw_line(pos,pos+Vector2(0,size.y),Color(0,0,0))
	draw_line(pos,pos+Vector2(size.x,0),Color(0,0,0))
	draw_line(pos+Vector2(size.x,0),pos+size,Color(0,0,0))
	draw_line(pos+Vector2(0,size.y),pos+size,Color(0,0,0))
	
	
	
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
				if(block == PresentRoom.MovingBlock and PresentRoom.Moving == true):
					markcolor.r *= 0.75
					markcolor.g *= 0.75
					markcolor.b *= 0.75
				DrawRoom(block.RoomIndex,bpos,borderdim,markcolor,num-1)
				draw_line(bpos,bpos+Vector2(0,borderdim.y),Color(0,0,0))
				draw_line(bpos,bpos+Vector2(borderdim.x,0),Color(0,0,0))
				draw_line(bpos+Vector2(borderdim.x,0),bpos+borderdim,Color(0,0,0))
				draw_line(bpos+Vector2(0,borderdim.y),bpos+borderdim,Color(0,0,0))
