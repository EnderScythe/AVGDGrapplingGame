extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func thrown_trigger():
	print("triggered")
	get_node("res://Player/Player.tscn").get_root().add_child(preload("res://Buyables/Repulsor.tscn").instantiate())
