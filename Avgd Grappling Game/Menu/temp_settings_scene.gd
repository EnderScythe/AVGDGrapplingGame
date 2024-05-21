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
		get_tree().change_scene_to_file("res://Menu/menu.tscn")

func _on_reset_keybinds_pressed():
	get_node("TabContainer").get_node("Controls").get_node("MarginContainer").get_node("VBoxContainer").get_node("HotkeyRebindButton").reset_default_keybinds()
