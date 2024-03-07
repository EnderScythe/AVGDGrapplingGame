extends Area2D

var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var segments = [self]
var velocities = []
#includes head
enum states {idle, aggro}
var segmentNum = 20
var state
var startAttack = false
var accel
var playerPosition
var lastPosition
var SPEED = 2000
var ACCELERATION = 1250
var OSCILLATION = 10
var SEGMENT_GAP = 20
var SPEED_CAP = 3000
var ANGLE = 0
#dir is false than angle is between 0 and 45 otherwise its between -45 and 0
var dir = false

func _ready():
	state = states.idle
	for i in range(segmentNum - 1):
		var wormSegment = segment.instantiate()
		add_sibling.call_deferred(wormSegment)
		segments.append(wormSegment)
		wormSegment.position = position
	for i in range(segmentNum):
		velocities.append(Vector2(0, 0))

func _process(delta):
	#var mousePosition = get_viewport().get_mouse_position()
	lastPosition = playerPosition
	playerPosition = get_parent().get_node("Player").position
	if state == states.idle:
		if playerPosition.distance_to(position) <= 2000:
			state = states.aggro
	if state == states.aggro:
		if !startAttack:
			velocities[0] = (playerPosition - position).normalized() * SPEED
			startAttack = true
		else:
			velocities[0] += (playerPosition - position).normalized() * ACCELERATION * delta
			if(velocities[0].length() >= SPEED_CAP):
				velocities[0] = velocities[0].normalized() * SPEED_CAP
			if dir == false:
				velocities[0] = velocities[0].rotated(delta/1000)
				ANGLE += 1
				if ANGLE > 45:
					dir = true
			else :
				velocities[0] = velocities[0].rotated(-delta/1000)
				ANGLE -= 1
				if ANGLE < -45:
					dir = false 
			velocities[0] = velocities[0].rotated(ANGLE)
			position += velocities[0] * delta
			get_node("Sprite2D").set_rotation(velocities[0].angle())
			for i in range(1, segmentNum):
				var segmentVector = segments[i - 1].position - segments[i].position
				var edgeVector = velocities[i - 1].rotated(PI).normalized() * OSCILLATION
				velocities[i] = (segmentVector + edgeVector) * SEGMENT_GAP
				segments[i].position += velocities[i] * delta
				segments[i].get_node("Sprite2D").set_rotation(velocities[i].angle())
			
