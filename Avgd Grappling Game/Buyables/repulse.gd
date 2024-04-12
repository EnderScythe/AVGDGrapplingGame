extends RigidBody2D

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(self.linear_velocity)
	#print(Vector2.ZERO)
	time += delta
	if time > .1:
		if self.linear_velocity == Vector2.ZERO:
			self.freeze = 1


func _on_timer_timeout():
	queue_free()
