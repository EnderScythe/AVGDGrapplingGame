extends Node2D

@onready var body = get_parent()

@export var hp = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_dmg(dmg):
	hp -= dmg
	
	if hp <= 0:
		body.queue_free()
	


