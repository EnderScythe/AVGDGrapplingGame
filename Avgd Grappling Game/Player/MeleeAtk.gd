extends Area2D

var lifespan = 0.4
var collision_exceptions = []
var dmg = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lifespan <= 0:
		queue_free()
	lifespan -= delta
	


func _on_body_entered(body):
	if collision_exceptions.has(body): return
	collision_exceptions.append(body)
	
	if body.has_node("HpComponent"):
		var hp = body.get_node("HpComponent")
		hp.take_dmg(dmg)
	
	





