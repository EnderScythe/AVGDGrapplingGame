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
	var playerPosition = get_parent().get_node("Player").position
	if state == states.idle:
		if playerPosition.distance_to(position) <= 2000:
			state = states.aggro
	if state == states.aggro:
		if !startAttack:
			velocities[0] = (playerPosition - position).normalized() * 1000
			startAttack = true
		else:
			velocities[0] += (playerPosition - position).normalized() * 75
			position += velocities[0] * delta
			get_node("Sprite2D").set_rotation(velocities[0].angle())
			for i in range(1, segmentNum):
				var segmentVector = segments[i - 1].position - segments[i].position
				var edgeVector = velocities[i - 1].rotated(PI).normalized()
				velocities[i] = (segmentVector + edgeVector) * 12
				segments[i].position += velocities[i] * delta
				segments[i].get_node("Sprite2D").set_rotation(velocities[i].angle())
			
