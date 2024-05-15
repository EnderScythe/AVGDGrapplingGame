extends TileMap

var time = 0
var dmgable = -1
var minable = -1
const LAVA_ID = [10, 11]
const ORE_ID = [7, 8]
var rng = RandomNumberGenerator.new()
@onready var player = get_parent().get_node("Player")
var geyser = preload("res://Environmental Hazards/Geyser/gay.tscn")
var stalactite = preload("res://Environmental Hazards/Stalactite/Stalactite.tscn")
var ACCELERATION = 300
var lava_velocity = Vector2(0, -1)

func _ready():
	hazardGeneration()

func _process(delta):
	time += delta
	var id = get_cell_source_id(0, Vector2i(player.position) / 144, true)
	if id in LAVA_ID:
		if time > dmgable:
			if player.velocity.y >= 0:
				player.velocity = Vector2(player.velocity.x, player.velocity.y / 2) 
			player.take_dmg(5) # Fair seemed to be 15 dmg every .75 secs = 30 dmg every 1.5 secs => 20 dmg per sec => 1 dmg per .05 secs
			dmgable = time + .33
	if time > minable:
		if id in ORE_ID:
			PlayerVariables.ores_carried += 4
			minable = time + PlayerVariables.swing_rate


func deal_enemy_damage(position, body, delta):
	time += delta
	var id = get_cell_source_id(0, Vector2i(position) / 144, true)
	if time > dmgable:
		if id in LAVA_ID:
			body.take_dmg(1) 

func hazardGeneration():
	var exposedCells = []
	var outsideCells = []
	var origin = get_used_rect().position
	var pos = (Vector2i(player.position) / 144)
	var playerSpawn = Rect2i(pos.x - 5, pos.y - 5, 10, 10)
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
		if playerSpawn.has_point(cellPosition):
			continue
		var neighborCells = get_surrounding_cells(cellPosition)
		var air_count = 0
		var neighbor
		for cell in neighborCells:
			if get_cell_source_id(0, cell, true) == -1 and get_used_rect().has_point(cell):
				air_count += 1
				neighbor = cell
		if air_count == 1:
			var rand = rng.randi_range(1, 100)
			var instance = null
			if neighbor.y < cellPosition.y:
				if rand <= 5:
					var lava_size_max = rng.randi_range(3, 6)
					var rightAvailable = true
					var leftAvailable = true
					for i in range(lava_size_max):
						var right = Vector2i(cellPosition.x + i, cellPosition.y)
						var left = Vector2i(cellPosition.x - i, cellPosition.y)
						var rightID = get_cell_source_id(0, right, true)
						var leftID = get_cell_source_id(0, left, true)
						var depth = rng.randi_range(0, 2)
						if rightID != -1 and rightID == 3 and rightAvailable:
							set_cell(0, right, 11, get_cell_atlas_coords(0, right, true), 0)
							var below = Vector2i(right.x, right.y - 1)
							for j in range(depth):
								if get_cell_source_id(0, below, true) == -1 or get_cell_source_id(0, Vector2i(below.x, below.y + 1), true) == -1:
									break
								else:
									set_cell(0, below, 10, get_cell_atlas_coords(0, below, true), 0)
									below = Vector2i(below.x, below.y + 1)
						else:
							rightAvailable = false
						if leftID != -1 and leftID == 3 and leftAvailable:
							set_cell(0, left, 11, get_cell_atlas_coords(0, left, true), 0)
							var below = Vector2i(left.x, left.y + 1);
							for j in range(depth):
								if get_cell_source_id(0, below, true) == -1 or get_cell_source_id(0, Vector2i(below.x, below.y + 1), true) == -1:
									break
								else:
									set_cell(0, below, 10, get_cell_atlas_coords(0, below, true), 0)
									below = Vector2i(below.x, below.y + 1)
						else:
							leftAvailable = false
			elif neighbor.y < cellPosition.y:
				if rand > 10 and rand <= 15 and get_cell_source_id(0, cellPosition, true) != 11:
					instance = geyser.instantiate()
					instance.position = cellPosition * 144
			elif neighbor.y > cellPosition.y:
				if rand > 15 and rand <= 20:
					instance = stalactite.instantiate()
					instance.position = cellPosition * 144
					instance.position.y += 240
			if instance != null:
				add_sibling.call_deferred(instance)	
