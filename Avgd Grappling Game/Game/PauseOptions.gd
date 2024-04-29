extends Control
var cam

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_viewport().get_camera_2d()
	$Volume.grab_focus()
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#position = cam.get_target_position()+Vector2(-500,-250)

func _input(event):
	if event.is_action_pressed("escape"):
		print("1")
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_back_pressed():
	get_tree().paused = false
	hide()


func _on_volume_pressed():
	print("Changing volume")


func _on_controls_pressed():
	print("Changing controls")
	get_tree().change_scene_to_file("res://Menu/temp_settings_scene.tscn")
