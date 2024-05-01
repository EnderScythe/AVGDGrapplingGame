extends Item

var boost_value = .8
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
	# Values for shields have not been worked out yet and cannot be implemented
	PlayerVariables.shield_recharge *= boost_value

func deapply_effect():
	PlayerVariables.shield_recharge /= boost_value

#func on_grapple():
	#player.MAX_LENGTH += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Shield Regen"

func get_descript():
	return "Upgrade to decrease the time it takes for the shield to start recharging!"

func get_img_path():
	return "res://Assets/Shop/Shop1.png"

func get_cost():
	return 4
