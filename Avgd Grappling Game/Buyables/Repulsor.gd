extends Item

var boost_value = 500
const increment = 300

# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	#There's no actual value for this yet
	player.MAX_LENGTH += boost_value

func deapply_effect():
	player.MAX_LENGTH -= boost_value

func on_grapple():
	player.MAX_LENGTH += increment
	boost_value += increment
	print(boost_value)

func get_upgrade():
	return "Repulsor"

func get_descript():
	return "Place a bubble which creates an area which redirects enemies elsewhere (useful when trying to mine ores with monsters around)!\n\nThe bubble has a limited duration and placing a bubble consumes one instance."

func get_img_path():
	return "res://Assets/Shop/Shop10.png"

func get_cost():
	return 7
