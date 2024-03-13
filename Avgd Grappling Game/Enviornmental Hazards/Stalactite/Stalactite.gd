extends RigidBody2D

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 3
	self.gravity_scale = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_body_entered(body):
	if !(body is TileMap):
		gravity_scale = 2


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		gravity_scale = 2
