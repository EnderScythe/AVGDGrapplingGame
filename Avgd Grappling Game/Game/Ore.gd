extends Area2D

@onready var player = get_node("res://Player/Player.tscn")
var max_hits = 5
var hits_left = max_hits
var in_ore = false
var time = 0
var mineable = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if in_ore == true and hits_left > 0 and Input.is_action_pressed("mine") and time > mineable:
		print("mined!")
		hits_left -= 1
		PlayerVariables.ores_carried += 1
		mineable = time + PlayerVariables.swing_rate/1000
		_check_amt()

func _check_amt():
	if hits_left == 0:
		queue_free()

func _on_body_entered(body):
	in_ore = true


func _on_body_exited(body):
	in_ore = false
