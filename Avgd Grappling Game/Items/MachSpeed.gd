extends Item
# Completed

var boost_value = 500
const increment = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	# Will probably change some value to turn on some collision/checks for the shield


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	player.SPEED += boost_value

func deapply_effect():
	player.SPEED -= boost_value

#func on_grapple():
	#player.SPEED += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Machine Speed"

func get_descript():
	return "Increases your base move speed!"

func get_img_path():
	return "res://Assets/Shop/Shop6.png"

func get_cost():
	return 2
