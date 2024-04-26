extends Node2D

var resource = preload("res://$metadata/GenericTexture.tscn")
var timer = 0
var active = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta * active
	
	if timer <= 0:
		var asset = resource.instantiate()
		asset.position = $/root/Global.get_player().position + Vector2.UP*1200
		add_sibling(asset)
		timer = 1
		active = 0
	
	
	



