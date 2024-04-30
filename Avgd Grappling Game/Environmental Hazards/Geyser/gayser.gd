extends Node2D
var firing = false
@onready var player = get_parent().get_node("Player")
var cooldown = false
var skewVal
var inc = false

# Called when the node enters the scene tree for the first time.
func _ready():
	skewVal = 0
	# $Hurtbox.set_deferred("disabled", false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#set_deferred("skew", randf_range(-.1, .1))
	pass


func _on_area_2d_body_entered(body):
	fire(body)
	firing = true


func fire(body):
	if(!cooldown):
		$DectectionArea/CollisionShape2D.set_deferred("disabled", true)
		$GPUParticles2D.set_deferred("emitting", true)
		if body is Player: body.take_hit(8, position.direction_to(body.position)*2400)
		cooldown = true

func _on_gpu_particles_2d_finished():
	$DectectionArea/CollisionShape2D.set_deferred("disabled", false)
	cooldown = false
	





