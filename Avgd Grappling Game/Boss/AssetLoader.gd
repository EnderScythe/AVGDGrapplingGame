extends Node2D

var resource = preload("res://Boss/Dust.tscn")
var timer = 0
var active = 1

@onready var asset = resource.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 3
	if Global.get_player() == null: return
	asset.position = $/root/Global.get_player().position + Vector2.UP*1200
	
	if get_tree().current_scene.name == "Arena": queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta * active
	
	if timer <= 0:
		# get_tree().current_scene.add_child(asset)
		add_sibling(asset)
		timer = 1
		active = 0
	
	
	



