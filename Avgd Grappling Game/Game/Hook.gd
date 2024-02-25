extends RigidBody2D

var player = null
var time = 0
var state = 0 # 0 = launch, 1 = grapple, 2 = retract
var length = 0 # grapple cord length, can be changed during grapple by player (rmb contract and shift extend)

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 3
	add_collision_exception_with(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if state == 0: launch_process(delta)
	# elif state == 1: grapple_process(delta)
	elif state == 2: retract_process(delta)
	queue_redraw()

func launch_process(delta):
	if get_contact_count() > 0: enter_grapple()
	if dist_player() > player.MAX_LENGTH: enter_retract()

func retract_process(delta):
	despawn()

func despawn():
	player.hook = null
	queue_free()

func enter_grapple():
	freeze = true
	length = dist_player()
	remove_collision_exception_with(player)
	state = 1

func enter_retract():
	add_collision_exception_with(player)
	state = 2

func dist_player():
	return position.distance_to(player.position)

func _draw():
	draw_line(Vector2.ZERO, (player.position - position).rotated(-rotation), Color(0.3, 0.4, 1), 4)
