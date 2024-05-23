extends AnimatedSprite2D
@onready var sprite = get_parent()
@onready var base_x_offset = position.x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_local_mouse_position().angle())
	flip_h = sprite.flip_h
	self.rotation = sprite.get_local_mouse_position().angle() - PI/2
	if sprite.flip_h:
		position.x = -base_x_offset
	else:
		position.x = base_x_offset
	
	pass


func get_hand_pos():
	return sprite.position + position * sprite.scale + Vector2(10, 75).rotated(rotation)
	

