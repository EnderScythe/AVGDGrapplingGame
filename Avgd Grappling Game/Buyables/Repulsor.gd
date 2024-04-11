extends Item

var num_repel = 0

# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("throw") and num_repel > 0:
		print("throw")
		player.get_parent().add_child(preload("res://Buyables/Repulse.tscn").instantiate())
		inventory.remove_item(self)
		num_repel -= 1

func apply_effect():
	num_repel += 1

func get_upgrade():
	return "Repulsor"

func get_descript():
	return "Place a bubble which creates an area which redirects enemies elsewhere (useful when trying to mine ores with monsters around)!\n\nThe bubble has a limited duration and placing a bubble consumes one instance."

func get_img_path():
	return "res://Assets/Shop/Shop10.png"

func get_cost():
	return 7
