extends Item

var boost_value = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	player.LAUNCH_VEL += boost_value

func deapply_effect():
	player.LAUNCH_VEL -= boost_value


# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

#const increment = 300
#func on_grapple():
	#player.LAUNCH_VEL += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Grapple Launch"

func get_descript():
	return "Upgrade to increase the speed the end of the grapple hook travels!"

func get_img_path():
	return "res://Assets/Shop/Shop4.png"

func get_cost():
	return 2
