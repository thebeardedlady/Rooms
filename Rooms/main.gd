extends Node2D



func _ready():
	add_child(load("res://level.tscn").instance())