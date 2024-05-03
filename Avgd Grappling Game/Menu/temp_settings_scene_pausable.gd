extends Control

@onready var temp = get_parent().get_node("settings").get_node("VBoxContainer")
var backClicked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false 

func _on_tab_container_tab_clicked(tab):
	if tab == 2: 
		#get_tree().paused = false
		visible = false
		temp.controls_pressed = false
		print("h")
		backClicked = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(temp.controls_pressed):
		visible = true
