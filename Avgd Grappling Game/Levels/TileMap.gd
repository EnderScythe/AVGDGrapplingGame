extends TileMap

var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var map = self.tile_map
	var tileIndex = map.getcellv(map.world_to_map(player.position))
	
	

