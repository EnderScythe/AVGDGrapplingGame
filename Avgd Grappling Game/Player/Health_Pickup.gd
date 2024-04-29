extends RigidBody2D

@onready var player = get_parent().get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if PlayerVariables.health < PlayerVariables.max_health:
		player.heal(15)
		queue_free()
