extends Item

var boosting = false
var boost_ready = false
var e_held = 0
var mult

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
	if Input.is_action_pressed("interact"):
		player.velocity.x = 0
		e_held += delta
	if e_held > PlayerVariables.rocket_timer:
		boost_ready = true
	
	if boost_ready == true && Input.is_action_just_released("interact"):
		boost_ready = false
		e_held = 0
		boosting = true
		if player.sprite.flip_h:
			mult = -1
		else:
			mult = 1
	if boosting == true:
		player.velocity.x = PlayerVariables.rocket_vel * mult
	
	if boosting == true && Input.is_action_just_pressed("interact"):
		boosting = false
		player.velocity.x = 0
	#if time <= 5:
		#if Input.is_action_just_pressed("interact"):
			#if Input.is_action_pressed("move_left"):
				#player.velocity.x -= PlayerVariables.rocket_vel
			#if Input.is_action_pressed("move_right"):
				#player.velocity.x += PlayerVariables.rocket_vel
			#time = 0

func apply_effect():
	if PlayerVariables.rocket_vel == 0:
		PlayerVariables.rocket_vel = boost_value
	PlayerVariables.rocket_vel += boost_value

func deapply_effect():
	PlayerVariables.rocket_vel -= boost_value

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
