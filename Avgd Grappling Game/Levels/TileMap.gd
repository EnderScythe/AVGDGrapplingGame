extends TileMap

var time = 0
var dmgable = -1
var minable = -1
const LAVA_ID = [10, 11]
const ORE_ID = [7, 8]
@onready var player = get_parent().get_node("Player")

func _ready():
	#print(get_used_cells(0))
	pass

func _process(delta):
	time += delta
	var id = get_cell_source_id(0, Vector2i(player.position) / 144, true)
	if time > dmgable:
		if id in LAVA_ID:
			player.take_dmg(1) # Takes 2 dmg every instance of damage
							   # Fair seemed to be 15 dmg every .75 dmg = 30 dmg every 1.5 secs => 20 dmg per sec => 1 dmg per .05 secs
			dmgable = time + .05
	if time > minable:
		if id in ORE_ID:
			PlayerVariables.ores_carried += 4
			minable = time + PlayerVariables.swing_rate
