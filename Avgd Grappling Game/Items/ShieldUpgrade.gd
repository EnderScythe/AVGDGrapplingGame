extends Item
@onready var shield = get_parent().get_parent().get_node("Shield_Sprite")
# Completed

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	# Will probably change some value to turn on some collision/checks for the shield

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply_effect():
	PlayerVariables.has_shield = true
	shield.trigger_shield_sprite()

func deapply_effect():
	PlayerVariables.has_Shield = false

func get_upgrade():
	return "Shield"

func get_descript():
	return "A shield will take some damage for you!\n\nYou can only buy ONE SHIELD, feel free to upgrade it though!"

func get_img_path():
	return "res://Assets/Shop/Shop0.png"

func get_cost():
	return 5
