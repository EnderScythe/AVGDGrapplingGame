extends CharacterBody2D

const HOOK_RES = preload("res://Game/Hook.tscn")
var hook = null

const SPEED = 600.0 # maximum horizontal speed from normal movement
const JUMP_VELOCITY = -1200.0 # velocity at start of jump
const ACCL = 4000.0 # how fast the player horizontally accelerates using normal movement
const AIR_ACCL_FAC = 0.5 # coefficient of ACCL when player is in the air
const FRIC = 800.0 # friction when on the ground
const LAUNCH_VEL = 3000.0 # velocity of launched hook
const HOOK_FRIC = 200.0 # affects hook tangential velocity when >= max range
const HOOK_PULL = 4800.0 # acceleration towards hook when player is outside range
const MAX_LENGTH = 1600.0 # maximum tether length (range)
const REEL_SPEED = 1200.0 # affects the rate at which tether length changes and the maximum centripetal velocity when pulling in
const PULL_BOOST_X = 1000.0 # p where Fc *= 1 + 2x/(x+p) and x is how much dist_to_hook exceeds tether length; p is the amount of extra distance such that Fc is doubled

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle jump.
		
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if (direction > 0 and velocity.x < SPEED) or (direction < 0 and velocity.x > -SPEED):
		velocity.x += direction * ACCL * delta * (1 if is_on_floor() else AIR_ACCL_FAC)
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRIC * delta)
	#else:
		#velocity.x = move_toward(velocity.x, 0, FRIC/5 * delta * abs(velocity.x / velocity.length()))
		#velocity.y = move_toward(velocity.y, 0, FRIC/5 * delta * abs(velocity.y / velocity.length()))
	
	if hook != null and hook.state == 1:
		var reel_dir = Input.get_axis("contract_grapple", "extend_grapple")
		if reel_dir:
			hook.length = clamp(hook.length + REEL_SPEED * reel_dir * delta, 0, MAX_LENGTH)
		
		grapple_process(delta)
	
	move_and_slide()

func launch_grapple(angle):
	if hook != null: return
	hook = HOOK_RES.instantiate()
	hook.player = self
	hook.position = position
	hook.set_rotation(angle)
	var initial_impulse = Vector2(LAUNCH_VEL, 0).rotated(angle)
	var inertia_fac = max(0, velocity.dot(initial_impulse) / initial_impulse.dot(initial_impulse))
	hook.apply_central_impulse(initial_impulse * (1 + inertia_fac))
	hook.translate(Vector2(80,0).rotated(angle))
	add_sibling(hook)

func _input(event):
	if event.is_action_pressed("launch_grapple"):
		if hook == null:
			launch_grapple(get_angle_to(get_global_mouse_position()))
		elif hook.state == 1:
			hook.enter_retract()

func grapple_process(delta):
	if hook == null: return
	if position.distance_to(hook.position) > hook.length:
		# move_and_collide((hook.position - position).normalized() * (position.distance_to(hook.position) - hook.length))
		var to_hook = hook.position - position
		var tangential_vel = velocity.project(to_hook.orthogonal())
		if tangential_vel.length() > HOOK_FRIC * delta:
			tangential_vel -= tangential_vel.normalized() * HOOK_FRIC * delta
		var centripetal_vel_fac = clamp(velocity.dot(to_hook) / to_hook.dot(to_hook), 0, REEL_SPEED / to_hook.length())
		var centripetal_force = position.direction_to(hook.position) * HOOK_PULL * (1 + 2*(to_hook.length()-hook.length)/(to_hook.length()-hook.length+PULL_BOOST_X)) * delta
		velocity = tangential_vel + to_hook * centripetal_vel_fac + centripetal_force





