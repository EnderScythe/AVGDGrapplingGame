extends Node

const temp_item_res = preload("res://Items/DoubleJump.tscn") # just to test if items work

var inventory = []

func _ready():
	inventory.append(temp_item_res.instantiate())
	pass

func _process(delta):
	pass
