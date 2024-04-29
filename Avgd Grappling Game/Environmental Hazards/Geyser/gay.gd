extends Node2D

var skewValue
var inc = true
# Called when the node enters the scene tree for the first time.
func _ready():
	skewValue = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	while(skewValue > -89 and skewValue < 89):
		match(inc):
			true:
				skewValue+=1
			false:
				skewValue-=1
				
	get_node("GPUParticles2D").set_deferred("skew", skewValue)
	print(skewValue)
