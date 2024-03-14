extends Control

var cam

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$ParallaxBackground/MenuList/VBoxContainer/StartButton.grab_focus()	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += 5
	pass

func _on_volume_pressed():
	print("Changing volume")

func _on_controls_pressed():
	print("Changing controls")
