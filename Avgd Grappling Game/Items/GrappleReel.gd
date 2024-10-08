extends Item


var boost_value = 500
const increment = 300

# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	# Will probably change some value to turn on some collision/checks for the shield


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	player.REEL_SPEED += boost_value

func deapply_effect():
	player.REEL_SPEED -= boost_value

#func on_grapple():
	#player.REEL_SPEED += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Grapple Reel"

func get_descript():
	return "Increases the speed you move towards the end of the grapple hook after it has attached to something!"

func get_img_path():
	return "res://Assets/Shop/Shop5.png"

func get_cost():
	return 3
