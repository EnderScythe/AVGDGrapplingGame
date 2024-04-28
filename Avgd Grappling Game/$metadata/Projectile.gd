extends Area2D

@onready var trail = $"Trail"

var trail_len = 16
var trail_pt_cd = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func trail_process(delta):
	trail.position = -position
	trail_pt_cd -= delta
	if trail_pt_cd <= 0:
		trail.add_point(position)
		trail_pt_cd = 0.01
		while trail.get_point_count() > trail_len:
			trail.remove_point(0)

