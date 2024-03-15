extends Node


var bought_shield
# upgrades
var shield_recharge
var shield_str
var grap_range
var grap_speed
var grap_reel
var move_spd
var swing_spd
var rocket
var jump_pad
var repel
var revivere

func _ready():
	bought_shield = false
	shield_recharge = 1 # if the upgrade starts at 1 then the upgrade is percentage based (kn) with k being the modified value, and n being the number of upgrades
	shield_str = 1
	grap_range = 0 # if the upgrade starts at 0 the upgrade increases linearly (k + cn) with k being the modified value, c being the slope, and n being the number of upgrades
	grap_speed = 0
	grap_reel = 0
	move_spd = 0
	swing_spd = 1
	rocket = false
	jump_pad = 0
	repel = 0
	revivere


func _process(delta):
	pass
