extends CharacterBody2D

@onready var global = $/root/Global
@onready var player = global.get_player()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var base_spd = 1000
var spd_decay = 120
var angle_var = PI/8
var min_angle = PI/4
var timer = 0
var low_bound_dist_lim = 2000

func _physics_process(delta):
	if player == null: return
	
	set_collision_mask_value(3, true)
	velocity.y += gravity * delta
	
	if player.position.y > position.y: set_collision_mask_value(3, false)
	
	if is_on_floor():
		jump() if timer < 3 else superjump()
	else:
		var sign = -1 if velocity.x < 0 else 1
		velocity.x = clamp(abs(velocity.x) - spd_decay * delta, 0, abs(velocity.x)) * sign
	
	if player.position.y < position.y: timer += delta
	else: timer = 0
	if timer >= 5: superjump()
	
	if position.y - player.position.y > low_bound_dist_lim: position.y = player.position.y + low_bound_dist_lim
	
	if velocity.y < 0: set_collision_mask_value(3, false)
	
	move_and_slide()
	

func jump():
	var dir = -clamp(abs(position.angle_to_point(player.position)), min_angle, PI-min_angle)
	dir += randf_range(-1, 1) * angle_var
	velocity = Vector2(base_spd, 0).rotated(dir)

func superjump():
	velocity.y = -sqrt(abs(2 * gravity * (player.position.y - position.y - 160)))
	velocity.x = (player.position.x - position.x) / -velocity.y * gravity * 0.5
	timer = 0



func _on_area_2d_body_entered(body):
	if body is Player:
		get_tree().call_deferred("change_scene_to_file", "res://$metadata/Arena.tscn")



