extends Item

var in_boost = false
var can_boost = false
var press_len = 0
var boost_value = 1000
const increment = 300
var time = PlayerVariables.rocket_timer

# I'm turning this item into Crystal dash from Hollow Knight

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if Input.is_action_pressed("interact") && in_boost == false:
		press_len += delta
		if press_len >= PlayerVariables.rocket_timer:
			can_boost = true
	if Input.is_action_just_released("interact") && can_boost == true:
		in_boost = true
		can_boost = false
	
	if in_boost == true:
		if player.sprite.flip_h == true: # if true, left; if false, right
			player.velocity.x = -PlayerVariables.rocket_vel
		else:
			player.velocity.x = PlayerVariables.rocket_vel
	
	if Input.is_action_just_pressed("interact") && in_boost == true:
		player.velocity.x = 0
		in_boost = false
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
