extends Node2D
class_name Item
# Base class for player Items. Includes various methods for applying item effects that can be implemented

var inventory
var player
var description
var item_name

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory = get_parent()
	player = inventory.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func apply_effect(): # applies initial effects of picking up the item, such as stat changes
	pass

func deapply_effect(): # inverse of apply_effect, completely reverting the changes made
	pass



