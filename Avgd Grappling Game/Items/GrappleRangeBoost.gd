extends Item
# Completed

var boost_value = 500
const increment = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	player.MAX_LENGTH += boost_value

func deapply_effect():
	player.MAX_LENGTH -= boost_value

#func on_grapple():
	#player.MAX_LENGTH += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Grapple Range"

func get_descript():
	return "Upgrade to increase the distance which the end of the grapple hook can travel before automatically terminating!"

func get_img_path():
	return "res://Assets/Shop/Shop3.png"

func get_cost():
	return 3
