extends Area2D

var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var segments = [self]
var velocities = []
#includes head
var segmentNum = 7

func _ready():
	for i in range(segmentNum - 1):
		var wormSegment = segment.instantiate()
		add_sibling.call_deferred(wormSegment)
		segments.append(wormSegment)
	for i in range(segmentNum):
		velocities.append(Vector2(0, 0))

func _process(delta):
	var mousePosition = get_viewport().get_mouse_position()
	velocities[0] = (mousePosition - position).normalized() * 500;
	position += velocities[0] * delta
	get_node("Sprite2D").set_rotation(velocities[0].angle())
	for i in range(1, segmentNum):
		var segmentVector = segments[i - 1].position - segments[i].position
		var edgeVector = velocities[i - 1].rotated(PI).normalized()
		velocities[i] = (segmentVector + edgeVector) * 5
		segments[i].position += velocities[i] * delta
		segments[i].get_node("Sprite2D").set_rotation(velocities[i].angle())
		
		
		
		
			
		
