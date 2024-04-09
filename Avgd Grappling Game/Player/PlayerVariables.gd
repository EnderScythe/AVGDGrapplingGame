extends Node

const temp_item_res = preload("res://Buyables/DoubleJump.tscn") # just to test if items work

var health = 100
var max_health = 100
var inventory = []
var swing_rate = 1000 # the number is in milliseconds (so default is 1 swing per second)
var rocket_vel = 0
var has_shield = false
var shield_recharge = 5000 # milliseconds (starts at 5 seconds)
var shield_strength = 3 # tanks 3 hits of any dmg?

var cost_inc = 0

func _ready():
	#inventory.append(temp_item_res.instantiate())
	#get_tree().get_node("Player").inventory.add_item(temp_item_res.instantiate())
	pass

func _process(delta):
	pass

