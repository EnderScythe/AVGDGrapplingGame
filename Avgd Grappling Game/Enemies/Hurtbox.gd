extends Area2D

@export var dmg = 1
@export var kb_scale = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body is Player:
			body.take_hit(dmg, global_position.direction_to(body.global_position) * kb_scale)


