extends Item

var mult
var l_start = -1
var l_ready = false
var r_start = -1
var r_ready = false
var on_cd = -1

var boost_value = 1000
const increment = 300
var time = 0

# this is an example script for an item that increases the player's 
# grapple range by 500px + an additional 300px every time they use the grappling hook
# this can be used as a template or reference for future item scripts

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if Input.is_action_just_pressed("move_left") && l_ready == false:
		l_start = time
		l_ready = true
	elif Input.is_action_just_pressed("move_left") && l_ready == true:
		player.velocity.x = -PlayerVariables.rocket_vel
		on_cd = time + PlayerVariables.rocket_timer
		r_ready = false
	if Input.is_action_just_pressed("move_right") && r_ready == false:
		r_start = time
		r_ready = true
	elif Input.is_action_just_pressed("move_right") && r_ready == true:
		player.velocity.x = PlayerVariables.rocket_vel
		on_cd = time + PlayerVariables.rocket_timer
		r_ready = false
	
	if time > l_start + .15:
		l_ready = false
	if time > r_start + .15:
		r_ready = false

func apply_effect():
	if PlayerVariables.rocket_vel == 0:
		PlayerVariables.rocket_vel = boost_value
	PlayerVariables.rocket_vel += boost_value
	PlayerVariables.rocket_timer *= .75

func deapply_effect():
	PlayerVariables.rocket_vel -= boost_value
	PlayerVariables.rocket_timer /= .75

#func on_grapple():
	#player.MAX_LENGTH += increment
	#boost_value += increment
	#print(boost_value)

func get_upgrade():
	return "Rocket"

func get_descript():
	return "Press 'E' to activate a rocket propelled booster! Achive insane velocities with this bad boy!"

func get_img_path():
	return "res://Assets/Shop/Shop8.png"

func get_cost():
	return 7
