extends Node2D
# Base class for player Items. Includes various methods for applying item effects that can be implemented

var inventory
var player

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



# to be added - more functions to connect item effects e.g. on_take_damage, on_jump, etc. whatever the items need


