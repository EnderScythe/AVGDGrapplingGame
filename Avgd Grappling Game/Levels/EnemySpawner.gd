extends Node2D

var rng = RandomNumberGenerator.new()
var bat = preload("res://Enemies/Bat/Bat.tscn")
var spider = preload("res://Enemies/Spider/Spider.tscn")
var worm = preload("res://Enemies/Worm/WormHead.tscn")
var slime = preload("res://Enemies/Slime/Slime.tscn")
var timer = 0;
const SPAWN_TIMER = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	generateRandomEnemy()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > SPAWN_TIMER:
		generateRandomEnemy()
		timer = 0

func generateRandomEnemy():
	var rand = rng.randi_range(0, 3)
	var enemy_instance = null
	match(rand):
		0:
			enemy_instance = bat.instantiate()
		1:
			enemy_instance = spider.instantiate()
		2:
			enemy_instance = worm.instantiate()
		3:
			enemy_instance = slime.instantiate()
	enemy_instance.position = position
	add_sibling.call_deferred(enemy_instance)

