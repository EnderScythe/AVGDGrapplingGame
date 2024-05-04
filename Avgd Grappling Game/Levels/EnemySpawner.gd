extends Node2D

var rng = RandomNumberGenerator.new()
var bat = preload("res://Enemies/Bat/Bat.tscn")
var spider = preload("res://Enemies/Spider/Spider.tscn")
var worm = preload("res://Enemies/Worm/WormHead.tscn")
var slime = preload("res://Enemies/Slime/Slime.tscn")
var prev_time = 0
var time = 0;
var enemies = []
var SPAWN_TIMER = rng.randi_range(10, 15)
#MAX NUMBER OF ENEMIES ONE ENEMYSPAWNER CAN HAVE MADE AT A TIME
const MAX_ENEMIES = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	generateRandomEnemy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	prev_time = time
	time += delta
	if int(time) % SPAWN_TIMER == 0 and int(prev_time) % SPAWN_TIMER != 0:
		generateRandomEnemy()
	if MAX_ENEMIES < enemies.size():
		for i in range(enemies.size() - MAX_ENEMIES):
			if(enemies[0] != null):
				if(enemies[0].name == "Worm"):
					for j in range(enemies[0].segments.size() - 1):
						enemies[0].segments[j + 1].queue_free()
				enemies[0].queue_free()
			

func generateRandomEnemy():
	var rand = rng.randi_range(1, 100)
	var enemy_instance = null
	#CURRENT SPAWN CHANCES: BAT -> 40%, SLIME -> 30%, SPIDER -> 20%, WORM->10%
	if rand <= 40:
		enemy_instance = worm.instantiate()
	elif rand > 40 and rand <= 70:
		enemy_instance = slime.instantiate()
	elif rand > 70 and rand <= 90:
		enemy_instance = spider.instantiate()
	else:
		enemy_instance = worm.instantiate()
	enemy_instance.position = position
	enemies.append(enemy_instance)
	add_sibling.call_deferred(enemy_instance)

