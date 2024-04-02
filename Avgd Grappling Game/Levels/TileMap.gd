extends TileMap

@onready var player = get_parent().get_node("Player")

func _ready():
	print(get_used_cells(0))


func _process(delta):
	var id = get_cell_source_id(0, Vector2i(player.position) / 144, true)
	if id == 10 or id == 11:
		get_tree().reload_current_scene()
	
	

