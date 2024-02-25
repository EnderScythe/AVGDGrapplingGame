extends RigidBody2D

const BASE_VEL = 1000
const MIN_FORCE = 2400

var player = null
var time = 0
var state = 0 # 0 = launch, 1 = grapple, 2 = retract
var length = 0 # grapple cord length, can be changed during grapple by player (rmb contract and shift extend)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(Vector2(BASE_VEL, 0).rotated(rotation))
	contact_monitor = true
	max_contacts_reported = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if state == 0: launch_process(delta)
	# elif state == 1: grapple_process(delta)
	elif state == 2: retract_process(delta)


func launch_process(delta):
	if get_contact_count() > 0: enter_grapple()

func grapple_process(delta):
	if dist_player() > length:
		var tangential_vel = player.velocity.project(position.direction_to(player.position).orthogonal())
		var pull = MIN_FORCE # MIN_FORCE * min((dist_player()-length)/length, 2)
		var centripetal_force = Vector2(pull, 0).rotated(player.position.angle_to_point(position))
		player.velocity = tangential_vel + centripetal_force * delta

func retract_process(delta):
	despawn()

func despawn():
	player.hook = null
	queue_free()

func enter_grapple():
	freeze = true
	length = dist_player()
	state = 1

func enter_retract():
	state = 2

func dist_player():
	return position.distance_to(player.position)
