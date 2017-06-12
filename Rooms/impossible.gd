
extends Node

onready var Rooms = get_node("../").Rooms
var RoomCycle = []
var ShowIndex = 0
var Count = 0.0

func _ready():
	pass


func _process(delta):
	Count += delta
	if(Count > 0.15):
		Count = 0.0
		for i in range(RoomCycle.size()):
			if(i == ShowIndex):
				RoomCycle[i].show()
			else:
				RoomCycle[i].hide()
		
		ShowIndex += 1
		if(ShowIndex > RoomCycle.size()):
			ShowIndex = 0


