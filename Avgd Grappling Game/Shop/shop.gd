extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shield_pressed():
	get_node("ShieldUpgrades/Shield").disabled = true
	print("Bought a shield!")

func _on_shield_mouse_entered():
	print("Shield will absorb x units")
