extends Area2D
var time = 0
var deposit = -1
var cooldown = .75
var in_molly = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if in_molly == true && time >= deposit && PlayerVariables.ores_carried > 0:
		PlayerVariables.ores_carried -= 1
		PlayerVariables.coins += 4
		deposit = time + cooldown


func _on_body_entered(body):
	deposit = time
	in_molly = true


func _on_body_exited(body):
	in_molly = false
