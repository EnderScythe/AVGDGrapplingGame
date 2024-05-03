extends CharacterBody2D

@onready var player = Global.get_player()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var base_spd = 1200
var spd_decay = 20
var angle_var = PI/6
var min_angle = PI/4
var jump_cd = 0.6
var jump_timer = 0
var boost_timer = 0
var max_boost = [1400, 1400] # x, y
var bounce_fac = 0.6

func _physics_process(delta):
	if player == null: return
	
	var collision = move_and_collide(velocity*delta, true)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * bounce_fac
	
	velocity.y += gravity * delta
	
	if is_on_floor():
		jump_timer -= delta
		velocity = Vector2.ZERO
	else:
		velocity = velocity.limit_length(velocity.length() - spd_decay * delta)
	
	if player.position.y < position.y: boost_timer += delta
	else: boost_timer += delta * 0.1
	
	if jump_timer < 0:
		jump() if boost_timer < 4 else superjump()
		jump_timer = jump_cd
	
	move_and_slide()
	set_collision_mask_value(3, true)
	

func jump():
	# var dir = -clamp(abs(position.angle_to_point(player.position)), min_angle, PI-min_angle) + randf_range(-1, 1) * angle_var
	var dir = min_angle + angle_var * randf_range(0, 1)
	if position.x > player.position.x:
		dir = PI - dir
	velocity = Vector2(base_spd, 0).rotated(-dir)
	

func superjump():
	velocity.y = min(-sqrt(abs(2 * gravity * (player.position.y - position.y - 160))), max_boost[1])
	velocity.x = min((player.position.x - position.x) / -velocity.y * gravity, max_boost[0])
	boost_timer = 0
	set_collision_mask_value(3, false)
	





