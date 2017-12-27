extends Node2D


var Index = 0
export var RoomIndex = -1
export var GridP = Vector2()
export var BoundingBox = Rect2()
export var ColorMod = Vector3(1,1,1)
var MouseOver = false
var Orientation = 3
var PresentRoom
var Rooms

func _ready():
	if(get_node("../../../") != get_viewport()):
		PresentRoom = get_node("../")
		Rooms = get_node("../../").Rooms
	else:
		Rooms = get_node("../").Rooms
		PresentRoom = get_node("../").DummyRoom

func _process(delta):
	update()

func _draw():
	DrawRoom(RoomIndex,BoundingBox.size * -0.5,BoundingBox.size,Rooms[RoomIndex].RoomColor,2)

func DrawRoom(index,pos,size,color,num):
	color.r *= ColorMod.x
	color.g *= ColorMod.y
	color.b *= ColorMod.z
	
	var bordercolor = color
	bordercolor.r *= 0.5
	bordercolor.g *= 0.5
	bordercolor.b *= 0.5
	
	var borderdim = size
	borderdim.x /= PresentRoom.BlocksGridSize.x
	borderdim.y /= PresentRoom.BlocksGridSize.y
	
	
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
		var numconnections = PresentRoom.NumConnections(Rooms[index].North)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].North[0][0]].South) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.x += (size.x - linegirth.x) * 0.5
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,size.x,borderdim.y),bordercolor)
	
	if(((type & 4)>>2) == 1):
		var numconnections = PresentRoom.NumConnections(Rooms[index].West)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].West[0][0]].East) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.y += (size.y - linegirth.y) * 0.5
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(((type & 2)>>1) == 1):
		var numconnections = PresentRoom.NumConnections(Rooms[index].South)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].South[0][0]].North) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,size.x,borderdim.y),bordercolor)
	
	if(((type & 1)>>0) == 1):
		var numconnections = PresentRoom.NumConnections(Rooms[index].East)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].East[0][0]].West) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(hasexit):
		draw_rect(Rect2(pos+(size-linegirth)*0.5,linegirth),Color(0,0,0))
	
	#TODO(ian): After making a trailer, change this to > not >=
	if(num >= 0):
		if(index == 8):
			var p = pos + Vector2(0.5*size.x,0.75*size.y)
			p -= Vector2(0.25*borderdim.x,0.5*borderdim.y)
			var size = Vector2(0.5*borderdim.x,borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
			p += Vector2(-0.5*borderdim.x,0.5*borderdim.y)
			size = Vector2(1.5*borderdim.x,0.5*borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
		if(index == 5):
			var p = pos + Vector2(0.75*size.x,1.5*borderdim.y)
			p -= Vector2(0.333333*borderdim.x,0)
			var size = Vector2(0.666666*borderdim.x,borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
		
		draw_line(pos,pos+Vector2(size.x,0),Color(0,0,0))
		draw_line(pos,pos+Vector2(0,size.x),Color(0,0,0))
		draw_line(pos+Vector2(size.x,0),pos+size,Color(0,0,0))
		draw_line(pos+Vector2(0,size.y),pos+size,Color(0,0,0))
		
		
		for roomblocks in Rooms[index].BlocksArray:
			for block in roomblocks:
				var bpos = Vector2()
				bpos.x = block.GridP.x*borderdim.x + pos.x
				bpos.y = block.GridP.y*borderdim.y + pos.y
				var markcolor
				markcolor = Rooms[block.RoomIndex].RoomColor
				markcolor.r *= 0.9
				markcolor.g *= 0.9
				markcolor.b *= 0.9
				DrawRoomOriented(block.RoomIndex,bpos,borderdim,markcolor,num-1,block.Orientation)


func DrawRoomOriented(index,pos,size,color,num,orientation):
	color.r *= ColorMod.x
	color.g *= ColorMod.y
	color.b *= ColorMod.z
	
	var bordercolor = color
	bordercolor.r *= 0.5
	bordercolor.g *= 0.5
	bordercolor.b *= 0.5
	
	var borderdim = size
	borderdim.x /= PresentRoom.BlocksGridSize.x
	borderdim.y /= PresentRoom.BlocksGridSize.y
	
	
	draw_rect(Rect2(pos,size),color)
	#draw_rect(Rect2(pos,borderdim),bordercolor)
	#draw_rect(Rect2(pos+size-borderdim,borderdim),bordercolor)
	#draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,borderdim.x,borderdim.y),bordercolor)
	#draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,borderdim.y),bordercolor)
	
	
	var linegirth = borderdim
	var linelength = (size + linegirth) * 0.5
	var type = Rooms[index].Type
	var hasexit = false
	
	var hasUp
	var hasLeft
	var hasDown
	var hasRight
	
	if(orientation == 3):
		hasUp = ((type&8)>>3) == 1
		hasLeft = ((type&4)>>2) == 1
		hasDown = ((type&2)>>1) == 1
		hasRight = ((type&1)>>0) == 1
	elif(orientation == 2):
		hasUp = ((type&1)>>0) == 1
		hasLeft = ((type&8)>>3) == 1
		hasDown = ((type&4)>>2) == 1
		hasRight = ((type&2)>>1) == 1
	elif(orientation == 1):
		hasUp = ((type&2)>>1) == 1
		hasLeft = ((type&1)>>0) == 1
		hasDown = ((type&8)>>3) == 1
		hasRight = ((type&4)>>2) == 1
	else:
		hasUp = ((type&4)>>2) == 1
		hasLeft = ((type&2)>>1) == 1
		hasDown = ((type&1)>>0) == 1
		hasRight = ((type&8)>>3) == 1
	
	
	
	
	if(hasUp):
		var numconnections
		if(orientation == 3):
			numconnections = PresentRoom.NumConnections(Rooms[index].North)
		elif(orientation == 2):
			numconnections = PresentRoom.NumConnections(Rooms[index].East)
		elif(orientation == 1):
			numconnections = PresentRoom.NumConnections(Rooms[index].South)
		else:
			numconnections = PresentRoom.NumConnections(Rooms[index].West)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].North[0][0]].South) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.x += (size.x - linegirth.x) * 0.5
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,size.x,borderdim.y),bordercolor)
	
	if(hasLeft):
		var numconnections
		if(orientation == 3):
			numconnections = PresentRoom.NumConnections(Rooms[index].West)
		elif(orientation == 2):
			numconnections = PresentRoom.NumConnections(Rooms[index].North)
		elif(orientation == 1):
			numconnections = PresentRoom.NumConnections(Rooms[index].East)
		else:
			numconnections = PresentRoom.NumConnections(Rooms[index].South)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].West[0][0]].East) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos
			p.y += (size.y - linegirth.y) * 0.5
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(hasDown):
		var numconnections
		if(orientation == 3):
			numconnections = PresentRoom.NumConnections(Rooms[index].South)
		elif(orientation == 2):
			numconnections = PresentRoom.NumConnections(Rooms[index].West)
		elif(orientation == 1):
			numconnections = PresentRoom.NumConnections(Rooms[index].North)
		else:
			numconnections = PresentRoom.NumConnections(Rooms[index].East)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].South[0][0]].North) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linegirth.x,linelength.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x,pos.y+size.y-borderdim.y,size.x,borderdim.y),bordercolor)
	
	if(hasRight):
		var numconnections
		if(orientation == 3):
			numconnections = PresentRoom.NumConnections(Rooms[index].East)
		elif(orientation == 2):
			numconnections = PresentRoom.NumConnections(Rooms[index].South)
		elif(orientation == 1):
			numconnections = PresentRoom.NumConnections(Rooms[index].West)
		else:
			numconnections = PresentRoom.NumConnections(Rooms[index].North)
		if(numconnections > 0):
			var linecolor
			if(numconnections == 1):
				#if(PresentRoom.NumConnections(Rooms[Rooms[index].East[0][0]].West) == 1):
				linecolor = Color(0,0,0)
				hasexit = true
				#else:
				#	linecolor = Color(0.5,0.5,0.5)
			else:
				linecolor = Color(0.5,0.5,0.5)
			var p = pos + ((size-linegirth) * 0.5)
			draw_rect(Rect2(p,Vector2(linelength.x,linegirth.y)),linecolor)
	else:
		draw_rect(Rect2(pos.x+size.x-borderdim.x,pos.y,borderdim.x,size.y),bordercolor)
	
	if(hasexit):
		draw_rect(Rect2(pos+(size-linegirth)*0.5,linegirth),Color(0,0,0))
	
	#TODO(ian): After making a trailer, change this to > not >=
	if(num >= 0):
		if(index == 8):
			var p = pos + Vector2(0.5*size.x,0.75*size.y)
			p -= Vector2(0.25*borderdim.x,0.5*borderdim.y)
			var size = Vector2(0.5*borderdim.x,borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
			p += Vector2(-0.5*borderdim.x,0.5*borderdim.y)
			size = Vector2(1.5*borderdim.x,0.5*borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
		if(index == 5):
			var p = pos + Vector2(0.75*size.x,1.5*borderdim.y)
			p -= Vector2(0.333333*borderdim.x,0)
			var size = Vector2(0.666666*borderdim.x,borderdim.y)
			draw_rect(Rect2(p,size),bordercolor)
		
		draw_line(pos,pos+Vector2(size.x,0),Color(0,0,0))
		draw_line(pos,pos+Vector2(0,size.x),Color(0,0,0))
		draw_line(pos+Vector2(size.x,0),pos+size,Color(0,0,0))
		draw_line(pos+Vector2(0,size.y),pos+size,Color(0,0,0))
		
		
		#for roomblocks in Rooms[index].BlocksArray:
		#	for block in roomblocks:
		#		var bpos = Vector2()
		#		bpos.x = block.GridP.x*borderdim.x + pos.x
		#		bpos.y = block.GridP.y*borderdim.y + pos.y
		#		var markcolor
		#		markcolor = Rooms[block.RoomIndex].RoomColor
		#		markcolor.r *= 0.9
		#		markcolor.g *= 0.9
		#		markcolor.b *= 0.9
		#		DrawRoomOriented(block.RoomIndex,bpos,borderdim,markcolor,num-1,block.Orientation)

func _on_Area2D_mouse_enter():
	MouseOver = true


func _on_Area2D_mouse_exit():
	MouseOver = false
