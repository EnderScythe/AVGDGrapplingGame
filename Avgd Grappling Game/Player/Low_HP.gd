extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	change_transparancy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_transparancy():
	var percent = 1 - float(PlayerVariables.health) / PlayerVariables.max_health
	percent = percent * percent * percent * percent
	print(percent)
	modulate.a = percent
