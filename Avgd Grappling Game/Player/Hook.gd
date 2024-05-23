extends RigidBody2D

var player = null
var time = 0
var state = 0 # 0 = launch, 1 = grapple, 2 = retract
var length = 0 # grapple cord length, can be changed during grapple by player (rmb contract and shift extend)
var hooked_body
var hooked_rel_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 3
	add_collision_exception_with(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if state == 0: launch_process(delta)
	elif state == 1: grapple_process(delta)
	elif state == 2: retract_process(delta)
	queue_redraw()

func launch_process(delta):
	# if get_contact_count() > 0:
		# hooked_body = get_colliding_bodies()[0]
		# hooked_rel_pos = position - hooked_body.position
		# enter_grapple()
	if dist_player() > player.MAX_LENGTH: enter_retract()

func grapple_process(delta):
	if hooked_body == null:
		enter_retract()
		return
	position = hooked_body.position + hooked_rel_pos

func retract_process(delta):
	despawn()

func despawn():
	player.hook = null
	queue_free()

func enter_grapple():
	set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC) # this SHOULD NOT be necessary
	call_deferred("set_freeze_enabled", true)
	# remove_collision_exception_with(player) # this DOES NOT WORK
	length = dist_player()
	state = 1

func enter_retract():
	add_collision_exception_with(player)
	state = 2

func dist_player():
	return position.distance_to(player.position)

func _draw():
	if player == null: return
	var dist = player.position - position
	var arm = player.get_node("AnimatedSprite2D").get_node("Arm")
	if arm != null:
		dist += arm.get_hand_pos()
	draw_line(Vector2.ZERO, dist.rotated(-rotation), Color(0.3, 0.4, 1), 4)
	


func _on_body_entered(body):
	if state == 0:
		hooked_body = body
		hooked_rel_pos = position - hooked_body.position
		enter_grapple()
