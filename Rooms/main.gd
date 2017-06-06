extends Node2D

var rooms = []
var blocks = []
var current = 3
var bsize = Vector2(64,64)
var moving = false
var movingblock


func _ready():
	#North,West,South,East
	rooms.append([[true,-1],[false,-1],[true,2],[true,1]])
	rooms.append([[false,-1],[true,0],[true,3],[false,-1]])
	rooms.append([[true,0],[false,-1],[false,-1],[true,3]])
	rooms.append([[true,1],[true,2],[false,-1],[false,-1]])
	rooms.append([[false,-1],[false,-1],[true,-1],[false,-1]])
	
	
	for i in range(rooms.size()):
		blocks.append([])
	
	
	blocks[0].append([Rect2(192,192,bsize.x-2,bsize.y-2),0])
	blocks[0].append([Rect2(128,192,bsize.x-2,bsize.y-2),4])
	blocks[0][0][0].pos = blocks[0][0][0].pos.snapped(bsize) + bsize*0.5
	blocks[0][1][0].pos = blocks[0][1][0].pos.snapped(bsize) + bsize*0.5
	
	
	
	
	set_process(true)



func _draw():
	draw_room(current,Vector2(0,0),Vector2(512,512),Color(0.25,0.55,0.35),4)
	
	if(blocks[current].size() > 0):
		for block in blocks[current]:
			var p = block[0].pos - Vector2(1,1)
			draw_rect(Rect2(p,bsize),Color(0,0,0))
			var color = Color(0.2,0.5,0.3)
			if(block == movingblock and moving == true):
				color = Color(0.15,0.45,0.25)
			draw_room(block[1],block[0].pos,block[0].size,color,1)

func draw_room(i,p,s,c,t):
	draw_rect(Rect2(p,s),c)
	
	var center = p + s*0.5
	if(rooms[i][0][0]):
		var np = p + Vector2(s.x*0.5,0)
		var color
		if(rooms[i][0][1] != -1):
			color = Color(0,0,0)
		else:
			color = Color(0.5,0.5,0.5)
		draw_line(np,center,color,t)
	else:
		draw_rect(Rect2(p.x,p.y,s.x,s.y*0.0625),Color(c.r+0.1,c.g+0.1,c.b+0.1))
	if(rooms[i][1][0]):
		var np = p + Vector2(0,s.y*0.5)
		var color
		if(rooms[i][1][1] != -1):
			color = Color(0,0,0)
		else:
			color = Color(0.5,0.5,0.5)
		draw_line(np,center,color,t)
	else:
		draw_rect(Rect2(p.x,p.y,s.x*0.0625,s.y),Color(c.r+0.1,c.g+0.1,c.b+0.1))
	if(rooms[i][2][0]):
		var np = p + Vector2(s.x*0.5,s.y)
		var color
		if(rooms[i][2][1] != -1):
			color = Color(0,0,0)
		else:
			color = Color(0.5,0.5,0.5)
		draw_line(np,center,color,t)
	else:
		draw_rect(Rect2(p.x,p.y+s.y*0.9375,s.x,s.y*0.0625),Color(c.r+0.1,c.g+0.1,c.b+0.1))
	if(rooms[i][3][0]):
		var np = p + Vector2(s.x,s.y*0.5)
		var color
		if(rooms[i][3][1] != -1):
			color = Color(0,0,0)
		else:
			color = Color(0.5,0.5,0.5)
		draw_line(np,center,color,t)
	else:
		draw_rect(Rect2(p.x+s.x*0.9375,p.y,s.x*0.0625,s.y),Color(c.r+0.1,c.g+0.1,c.b+0.1))

func _process(delta):
	if(Input.is_key_pressed(KEY_UP)):
		if(rooms[current][0][0] and rooms[current][0][1] != -1):
			current = rooms[current][0][1]
			moving = false
	if(Input.is_key_pressed(KEY_LEFT)):
		if(rooms[current][1][0] and rooms[current][1][1] != -1):
			current = rooms[current][1][1]
			moving = false
	if(Input.is_key_pressed(KEY_DOWN)):
		if(rooms[current][2][0] and rooms[current][2][1] != -1):
			current = rooms[current][2][1]
			moving = false
	if(Input.is_key_pressed(KEY_RIGHT)):
		if(rooms[current][3][0] and rooms[current][3][1] != -1):
			current = rooms[current][3][1]
			moving = false
	
	
	if(moving == false):
		if(blocks[current].size() > 0):
			for block in blocks[current]:
				if(block[0].has_point(get_global_mouse_pos()) and Input.is_action_pressed("select_block")):
					moving = true
					movingblock = block
	else:
		if(Input.is_action_pressed("select_block")):
			var pos = get_global_mouse_pos().snapped(bsize)/bsize.x
			if(pos.x > 0 and pos.x < 8 and pos.y > 0 and pos.y < 8):
				var hitblock = false
				var temp = get_global_mouse_pos().snapped(bsize) - bsize*0.5
				for block in blocks[current]:
					if(block != movingblock):
						if(temp == block[0].pos):
							hitblock = true
							break
				if(hitblock == false):
					movingblock[0].pos = temp
		else:
			moving = false
	
	
	update()