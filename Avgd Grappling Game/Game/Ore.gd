extends Area2D

var time = 0
var white = -1
var max_hits = 5
var hits_left = max_hits

# Called when the node enters the scene tree for the first time.
func _ready():
	$GPUParticles2D.emitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time < white:
		$Sprite2D.modulate = Color(2, 2, 2)
		$GPUParticles2D.emitting = true
	else:
		$Sprite2D.modulate = Color(1, 1, 1)
		$GPUParticles2D.emitting = false

func _check_amt():
	if hits_left == 0:
		queue_free()


func _on_area_entered(area):
	if area.name == "MeleeAtk":
		hits_left -= 1
		PlayerVariables.ores_carried += 1
		white = time + .25
		_check_amt()
	

