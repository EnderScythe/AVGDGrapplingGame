extends Item

var boost_value = .75
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
	#There's no actual value for this yet
	PlayerVariables.swingspeed *= boost_value # we have nothing that utilizes this, so there's no way to test if this works

func deapply_effect():
	PlayerVariables.swingspeed /= boost_value

#func on_grapple():
	#player.MAX_LENGTH += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Swing Speed"

func get_descript():
	return "Decreases the time between pickaxe swings!"

func get_img_path():
	return "res://Assets/Shop/Shop7.png"

func get_cost():
	return 3
