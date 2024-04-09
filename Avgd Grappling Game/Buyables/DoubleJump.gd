extends Item

var max_jump = 1
var cur_jump = 1
var jump_velocity = -1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_on_floor():
		cur_jump = max_jump


func _input(event):
	if event.is_action__pressed("jump") and !player.is_on_floor() and cur_jump > 0:
		player.velocity.y = jump_velocity
	cur_jump -= 1

func get_upgrade():
	return "Double Jump"

func get_descript():
	return "Place a pad (able to be placed in the middle of air) to jump again; the pad can be used multiple times!\n\nYou can JUMP ON THE PAD multiple times however you can only PLACE DOWN the pad ONCE."
# note: this is not what the item currently does

func get_img_path():
	return "res://Assets/Shop/Shop9.png"

func get_cost():
	return 7
