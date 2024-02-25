extends CharacterBody2D

const HOOK_RES = preload("res://Game/Hook.tscn")
var hook = null

const SPEED = 500.0
const JUMP_VELOCITY = -600.0
const ACCL = 8
const FRIC = 800

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if (direction > 0 and velocity.x < SPEED) or (direction < 0 and velocity.x > -SPEED):
		velocity.x += direction * SPEED * ACCL * delta
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRIC * delta)
	
	if hook != null and hook.state == 1: grapple_process(delta)
	
	move_and_slide()

func launch_grapple(angle):
	if (hook != null): return
	hook = HOOK_RES.instantiate()
	hook.player = self
	hook.position = position
	hook.set_rotation(angle)
	hook.translate(Vector2(120,0).rotated(angle))
	add_sibling(hook)

func _input(event):
	if event is InputEventMouseButton:
		launch_grapple(get_angle_to(get_global_mouse_position()))

func grapple_process(delta):
	if hook == null: return
	if position.distance_to(hook.position) > hook.length:
		var tangential_vel = velocity.project(position.direction_to(hook.position).orthogonal())
		if tangential_vel.length() > 500 * delta:
			tangential_vel -= tangential_vel.normalized() * 500 * delta
		var centripetal_force = Vector2(2400, 0).rotated(position.angle_to_point(hook.position))
		velocity = tangential_vel + centripetal_force * delta





