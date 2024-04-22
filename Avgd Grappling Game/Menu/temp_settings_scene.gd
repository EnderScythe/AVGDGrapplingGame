extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#$ParallaxBackground/MenuList/VBoxContainer/Volume.grab_focus()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tab_container_tab_clicked(tab):
	if tab == 2:
		print("wtf")
		get_tree().change_scene_to_file("res://Menu/menu.tscn")

