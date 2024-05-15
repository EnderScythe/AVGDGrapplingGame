extends Control
var cam
var controls_pressed = false

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
		if (get_parent().get_parent().get_node("TempSettingsScene").visible == false and visible == false):
			get_tree().paused = true
			visible = true
		elif (get_parent().get_parent().get_node("TempSettingsScene").visible):
			get_parent().get_parent().get_node("TempSettingsScene").visible=false
			visible = true
			get_tree().paused = true
		elif (get_parent().get_parent().get_node("TempSettingsScene").visible == false):
			visible = false
			get_tree().paused = false

func _on_back_pressed():
	get_tree().paused = false
	visible = false
	get_parent().get_parent().get_node("TempSettingsScene").visible = false
	
	


func _on_volume_pressed():
	print("Changing volume")


func _on_controls_pressed():
	print("Changing controls")
	hide()
	get_parent().get_parent().get_node("TempSettingsScene").visible = true
	get_parent().get_parent().get_node("TempSettingsScene").get_node("TabContainer").current_tab=1

