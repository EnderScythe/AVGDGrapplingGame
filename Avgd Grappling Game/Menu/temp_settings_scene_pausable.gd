extends Control

var backClicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false 

func _on_tab_container_tab_clicked(tab):
	if tab == 2: 
		visible = false
		get_parent().get_node("settings").get_node("VBoxContainer").visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
