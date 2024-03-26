extends TileMap

@onready var player = get_parent().get_node("Player")
var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#var map = get_tree().get_nodes_in_group("TileMap")
	#for i in map:
		#tiles.append(local_to_map(i.get_position));
	#for i in tiles:
		#print(tiles)
		#print(", ")
	print(get_used_cells(0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var id = get_cell_source_id(0, Vector2i(player.position), true)
	print(Vector2i(player.position) / 144)
	#x`if(id != -1):
		#print(id)
	
	

