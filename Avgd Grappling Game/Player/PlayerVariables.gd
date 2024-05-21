extends Node

const temp_item_res = preload("res://Items/DoubleJump.tscn") # just to test if items work

var max_health = 100
var health = max_health
var coins = 0
var inventory = []
var swing_cd = 0.6 # in seconds (so default is 1 swing per .6 seconds)
var rocket_vel = 0
var rocket_timer = 3
var has_shield = false
var shield_recharge = 5 # in seconds (starts at 5 seconds)
var shield_max = 3 # tanks 3 hits of any dmg?
var shield_health = shield_max
var ores_carried = 0
var shield_broken = false

var cost_inc = 0

func _ready():
	# inventory.append(temp_item_res.instantiate())
	pass

func _process(delta):
	pass

