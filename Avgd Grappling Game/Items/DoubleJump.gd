extends Item

var max_jump = 0
var cur_jump = 0
var jump_velocity = -1200.0
var times_jumped = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	print(times_jumped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.is_on_floor():
		cur_jump = max_jump


func _input(event):
	if event.is_action_pressed("jump") and !player.is_on_floor() and cur_jump > 0:
		player.velocity.y = jump_velocity
		cur_jump -= 1
		times_jumped += 1
		print(times_jumped)

func apply_effect(): # applies initial effects of picking up the item, such as stat changes
	max_jump += 1

func deapply_effect(): # inverse of apply_effect, completely reverting the changes made
	max_jump -= 1

func get_upgrade():
	return "Double Jump"

func get_descript():
	return "Tired of only jumping once? Jump more now, with this item!"
# note: this is not what the item currently does

func get_img_path():
	return "res://Assets/Shop/Shop9.png"

func get_cost():
	return 7
