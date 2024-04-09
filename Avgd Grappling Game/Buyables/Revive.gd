extends Item

var cur_revives = 0
func _ready():
	super._ready()
	# Will probably change some value to turn on some collision/checks for the shield


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _died():
	print("Would you lose? Nah, I'd win")
	PlayerVariables.health = PlayerVariables.max_health

func get_upgrade():
	return "Revive"

func get_descript():
	return "Place a respawn beacon in a location of your choosing. If you get destroyed, you will be reconstructed at this location after a brief period of time!\n\nONLY ONE REVIVE IS AVAILABLE PER SHOP. REVIVE IS CONSUMED WHEN PLACED."

func get_img_path():
	return "res://Assets/Shop/Shop11.png"

func get_cost():
	return 10
