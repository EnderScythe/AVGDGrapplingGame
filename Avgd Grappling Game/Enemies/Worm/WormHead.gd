extends Area2D

var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var segments = [self]
var velocities = []
#includes head
enum states {idle, aggro}
var segmentNum = 10
var state
var startAttack = false
var accel
var playerPosition
var lastPosition
var INITIAL_SPEED = 3000
var ACCELERATION = 1250
var OSCILLATION = 50
var SEGMENT_GAP = 170
var SPEED_CAP = 2000

func _ready():
	self.z_index = segmentNum - 1
	self.rotate(PI/2)
	state = states.idle
	for i in range(segmentNum - 1):
		var wormSegment = segment.instantiate()
		add_sibling.call_deferred(wormSegment)
		segments.append(wormSegment)
		wormSegment.position = position
		wormSegment.z_index = segmentNum - 1 - i
		if i % 2 == 0:
			wormSegment.rotate(3*PI/2)
		else:
			wormSegment.rotate(PI/2)
	for i in range(segmentNum):
		velocities.append(Vector2(0, 0))
	

func _process(delta):
	var mousePosition = get_viewport().get_mouse_position()
	playerPosition = get_parent().get_node("Player").position
	if state == states.idle:
		if playerPosition.distance_to(position) <= 2000:
			state = states.aggro
	if state == states.aggro:
		if !startAttack:
			velocities[0] = (playerPosition - position).normalized() * INITIAL_SPEED
			startAttack = true
		else:
			velocities[0] += (playerPosition - position).normalized() * ACCELERATION * delta
			if(velocities[0].length() >= SPEED_CAP):
				velocities[0] = velocities[0].normalized() * SPEED_CAP
			position += velocities[0] * delta
			$AnimatedSprite2D.play("worm_head_anim")			
			get_node("AnimatedSprite2D").set_rotation(velocities[0].angle())
			for i in range(1, segmentNum):
				var segmentVector = segments[i - 1].position - segments[i].position
				var edgeVector = velocities[i - 1].rotated(PI).normalized() * OSCILLATION
				velocities[i] = (segmentVector + edgeVector) * SPEED_CAP / SEGMENT_GAP
				if(velocities[i].length() >= SPEED_CAP):
					velocities[i] = velocities[i].normalized() * SPEED_CAP
				segments[i].position += velocities[i] * delta
				segments[i].get_node("AnimatedSprite2D").play("worm_segment_anim")
				segments[i].get_node("AnimatedSprite2D").set_rotation(velocities[i].angle())
