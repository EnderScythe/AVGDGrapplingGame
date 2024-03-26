extends Item

var boost_value = 500
const increment = 300

# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	item_name = "Grapple Launch"
	description = "Upgrade to increase the speed the end of the grapple hook travels!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	player.LAUNCH_VEL += boost_value

func deapply_effect():
	player.LAUNCH_VEL -= boost_value

func on_grapple():
	player.LAUNCH_VEL += increment
	boost_value += increment
	print(boost_value)
