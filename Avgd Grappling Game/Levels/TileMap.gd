extends TileMap

var time = 0
var dmgable = -1
var minable = -1
const LAVA_ID = [10, 11]
const ORE_ID = [7, 8]
var rng = RandomNumberGenerator.new()
@onready var player = get_parent().get_node("Player")
var geyser = preload("res://Environmental Hazards/Geyser/gay.tscn")

func _ready():
	proceduralGeneration()

func _process(delta):
	time += delta
	var id = get_cell_source_id(0, Vector2i(player.position) / 144, true)
	if time > dmgable:
		if id in LAVA_ID:
			print(get_cell_alternative_tile(0, Vector2i(player.position) / 144, true))
			player.take_dmg(1) # Takes 2 dmg every instance of damage
							   # Fair seemed to be 15 dmg every .75 dmg = 30 dmg every 1.5 secs => 20 dmg per sec => 1 dmg per .05 secs
			dmgable = time + .05
	if time > minable:
		if id in ORE_ID:
			PlayerVariables.ores_carried += 4
			minable = time + PlayerVariables.swing_rate

#<<<<<<< Updated upstream
func deal_enemy_damage(position, body, delta):
	time += delta
	var id = get_cell_source_id(0, Vector2i(position) / 144, true)
	if time > dmgable:
		if id in LAVA_ID:
			body.take_dmg(1) 
#=======
func proceduralGeneration():
	var exposedCells = []
	var outsideCells = []
	var origin = get_used_rect().position
	var end = get_used_rect().end
	for i in range(end.x - origin.x):
		outsideCells.append(Vector2i(origin.x + i, origin.y))
		outsideCells.append(Vector2i(origin.x + i, end.y))
	for i in range(end.y - origin.y):
		outsideCells.append(Vector2i(origin.x, origin.y + i))
		outsideCells.append(Vector2i(end.x, origin.y + i))
	for cellPosition in get_used_cells(0):
		var neighborCells = get_surrounding_cells(cellPosition)
		for neighbor in neighborCells:
			var cellID = get_cell_source_id(0, neighbor, true)
			if cellID == -1 and get_used_rect().has_point(neighbor):
				exposedCells.append(cellPosition)
				break
	for cellPosition in exposedCells:
		var neighborCells = get_surrounding_cells(cellPosition)
		var air_count = 0
		var neighbor
		for cell in neighborCells:
			if get_cell_source_id(0, cell, true) == -1 and get_used_rect().has_point(cell):
				air_count += 1
				neighbor = cell
		if air_count == 1 and neighbor.y < cellPosition.y:
			var rand = rng.randi_range(1, 100)
			if rand <= 5:
				var instance = geyser.instantiate()
				instance.position = cellPosition * 144
				add_sibling.call_deferred(instance)
			elif rand > 5 and rand <= 15:
				set_cell(0, cellPosition, 11, get_cell_atlas_coords(0, cellPosition, true), 0)
					
					
		
#>>>>>>> Stashed changes
