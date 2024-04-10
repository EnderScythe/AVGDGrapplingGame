extends Area2D

var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var tail = preload("res://Enemies/Worm/WormTail.tscn")
var segments = [self]
var velocities = []
#includes head
enum states {idle, aggro}
var segmentNum = 12
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
var STANDARD_DEVIATION = 4
var MEAN = 9
var rng = RandomNumberGenerator.new()

 

func _ready():
	#var rand = randf() - 0.5
	#for i in range(1, MEAN):
		#if rand > integrate(MEAN, i):
			#segmentNum = i;
			#break
	segmentNum = rng.randi_range(6, 15)
	self.z_index = segmentNum - 1
	self.rotate(PI/2)
	state = states.idle
	for i in range(segmentNum - 2):
		var wormSegment = segment.instantiate()
		add_sibling.call_deferred(wormSegment)
		segments.append(wormSegment)
		wormSegment.position = position
		wormSegment.z_index = segmentNum - 1 - i
		if i % 2 == 0:
			wormSegment.rotate(3*PI/2)
		else:
			wormSegment.rotate(PI/2)
	var wormTail = tail.instantiate()
	add_sibling.call_deferred(wormTail)
	segments.append(wormTail)
	wormTail.position = position
	wormTail.z_index = 0
	wormTail.rotate(PI/2)
	for i in range(segmentNum):
		velocities.append(Vector2(0, 0))
	

func _process(delta):
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
				if(i == segmentNum - 1):
					segments[i].get_node("AnimatedSprite2D").play("worm_tail_anim")
				else:
					segments[i].get_node("AnimatedSprite2D").play("worm_segment_anim")
				segments[i].get_node("AnimatedSprite2D").set_rotation(velocities[i].angle())
				

#func integrate(lower_bound, upper_bound):
	#var dx = 0.1
	#var sum = 0;
	#if lower_bound > upper_bound:
		#dx *= -1
	#for i in range(lower_bound * 10, upper_bound * 10, dx * 10):
		#sum += dx * normaldist(i / 10, STANDARD_DEVIATION, MEAN)
	#return sum
#func normaldist(x, stdev, mean):
	#var e = 2.71828
	#var p1 = 1 / (stdev * sqrt(2 * PI))
	#var p2 = -0.5 * ((x - mean) / stdev) ** 2
	#return p1 * e ** p2
	
