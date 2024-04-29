extends Area2D

@onready var player = get_node("res://Player/Player.tscn")
var max_hits = 7
var hits_left = max_hits

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _check_amt():
	if hits_left == 0:
		queue_free()


func _on_area_entered(area):
	if area.name == "MeleeAtk":
		print("mined!")
		hits_left -= 1
		PlayerVariables.ores_carried += 1
		_check_amt()
	

