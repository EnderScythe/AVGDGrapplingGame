extends Node2D
var firing = false
@onready var player = get_parent().get_node("Player")
var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	fire()
	firing = true


func fire():
	if(!cooldown):
		get_node("DectectionArea/CollisionShape2D").set_deferred("disabled", true)
		get_node("GPUParticles2D").set_deferred("emitting", true)
		player.take_dmg(8)
		cooldown = true

func _on_gpu_particles_2d_finished():
	get_node("DectectionArea/CollisionShape2D").set_deferred("disabled", false)
	cooldown = false
	





