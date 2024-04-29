extends Node2D
var firing = false
@onready var player = get_parent().get_node("Player")
var cooldown = false
var skewVal
var inc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	skewVal = 0
	$Hurtbox.set_deferred("disabled", true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set_deferred("skew", randf_range(-.1, .1))
	pass


func _on_area_2d_body_entered(body):
	fire()
	firing = true


func fire():
	if(!cooldown):
		$DectectionArea/CollisionShape2D.set_deferred("disabled", true)
		$Hurtbox.set_deferred("disabled", false)
		$GPUParticles2D.set_deferred("emitting", true)
		cooldown = true

func _on_gpu_particles_2d_finished():
	$DectectionArea/CollisionShape2D.set_deferred("disabled", false)
	$Hurtbox.set_deferred("disabled", false)
	cooldown = false
	





