extends Area2D

var velocity = Vector2(0, 0);
var segment = preload("res://Enemies/Worm/WormSegment.tscn")
var parts = [self]; 

# Called when the node enters the scene tree for the first time.
func _ready():
	var wormSegment = segment.instantiate()
	add_sibling.call_deferred(wormSegment);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousePosition = get_viewport().get_mouse_position()
	velocity = (mousePosition - position).normalized() * 500;
	position += velocity * delta
	pass
