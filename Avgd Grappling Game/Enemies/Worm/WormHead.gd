extends Area2D

var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var segments = [self]
var acceleration = []
var velocities = []
#includes head
var segmentNum = 20



func _ready():
	for i in range(segmentNum - 1):
		var wormSegment = segment.instantiate()
		add_sibling.call_deferred(wormSegment)
		segments.append(wormSegment)
	for i in range(segmentNum):
		velocities.append(Vector2(0, 0))

func _process(delta):
	#for velocity in velocities:
		#if position.y <= 1090:
			#velocity.y = 1
		#elif position.y >= 5300:
			#velocity.y = -1
		#if position.x <= -70:
			#velocity.x = 1
		#elif position.x >= 10200:
			#velocity.x = -1
		#velocity = velocity.normalized()
	#var mousePosition = get_viewport().get_mouse_position()
	var playerPosition = get_parent().get_node("Player").position
	velocities[0] = (playerPosition - position).normalized() * 500;
	#velocities[0] += acceleration[0] * delta
	position += velocities[0] * delta
	get_node("Sprite2D").set_rotation(velocities[0].angle())
	for i in range(1, segmentNum):
		var segmentVector = segments[i - 1].position - segments[i].position
		var edgeVector = velocities[i - 1].rotated(PI).normalized()
		velocities[i] = (segmentVector + edgeVector) * 2.5
		#velocities[i] += acceleration[i];
		segments[i].position += velocities[i] * delta
		segments[i].get_node("Sprite2D").set_rotation(velocities[i].angle())
		
		
		
		
			
		
