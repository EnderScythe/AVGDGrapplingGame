extends Node2D

#const temp_item_res = preload("res://Items/GrappleRangeBoost.tscn") # just to test if items work
@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
var selected_upgrades = []
var buyable = ["", "", ""]
var shield = preload("res://Items/ShieldUpgrade.tscn")
var shield_regen = preload("res://Items/ShieldRegen.tscn")
var shield_strength = preload("res://Items/ShieldStrength.tscn")
var grapple_range = preload("res://Items/GrappleRangeBoost.tscn")
var grapple_launch = preload("res://Items/GrappleLaunch.tscn")
var grapple_reel = preload("res://Items/GrappleReel.tscn")
var machine_speed = preload("res://Items/MachSpeed.tscn")
var pick_swing = preload("res://Items/PickSwing.tscn")
var rocket = preload("res://Items/Rocket.tscn")
var double_jump = preload("res://Items/DoubleJump.tscn")
var repulsor = preload("res://Items/Repulsor.tscn")
var revive = preload("res://Items/Revive.tscn")
var UPGRADES = [
	shield,
	shield_regen,
	shield_strength,
	grapple_range,
	grapple_launch,
	grapple_reel,
	machine_speed,
	pick_swing,
	rocket,
	double_jump,
	repulsor,
	revive
]

var In_Option_1 = false
var In_Option_2 = false
var In_Option_3 = false
var in_reroll = false
var money = PlayerVariables.coins
var reroll_cost = 1 + ceil(1 * PlayerVariables.cost_inc)
func _ready():
	$Upgrade_Description.visible = false
	var _rng = RandomNumberGenerator.new
	roll_shop()

func roll_shop():
	selected_upgrades = []
	# Randomly select 3 integers from the bounds [0, n_upgrades]
	while selected_upgrades.size() < 3:
		# While randomly selecting integers, check if it's already been used and re-generate if it has
		var num = randi_range(0, UPGRADES.size()-1)
		var selected
		if num < 3:
			# Check if it's a valid upgrade (the shields (probably going to be values 1-3) need to be double checked)
			selected = randi_range(1, 2)
			if PlayerVariables.has_shield == false:
				selected = 0
		else:
			selected = num
		var already_selected = false
		for x in selected_upgrades.size():
			if selected_upgrades[x] == selected:
				already_selected = true
				pass
		if already_selected == false:
			selected_upgrades.append(selected)
	
	buyable[0] = UPGRADES[selected_upgrades[0]].instantiate()
	buyable[1] = UPGRADES[selected_upgrades[1]].instantiate()
	buyable[2] = UPGRADES[selected_upgrades[2]].instantiate()
	get_node("Option_1").text = buyable[0].get_upgrade()
	get_node("Option_2").text = buyable[1].get_upgrade()
	get_node("Option_3").text = buyable[2].get_upgrade()
	
	$Option_1_Area/Sprite2D.set_texture(load(buyable[0].get_img_path()))
	$Option_2_Area/Sprite2D.set_texture(load(buyable[1].get_img_path()))
	$Option_3_Area/Sprite2D.set_texture(load(buyable[2].get_img_path()))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if in_reroll == true and money >= reroll_cost:
			money -= reroll_cost
			reroll_cost += 1
			roll_shop()
		if In_Option_1 == true and money >= buyable[0].get_cost():
			money -= buyable[0].get_cost()
			player.inventory.add_item(buyable[0])
			buyable[0] = UPGRADES[selected_upgrades[0]].instantiate()
			print("Purchased " + buyable[0].get_upgrade())
		if In_Option_2 == true and money >= buyable[1].get_cost():
			money -= buyable[1].get_cost()
			player.inventory.add_item(buyable[1])
			buyable[1] = UPGRADES[selected_upgrades[1]].instantiate()
			print("Purchased " + buyable[1].get_upgrade())
		if In_Option_3 == true and money >= buyable[2].get_cost():
			money -= buyable[2].get_cost()
			player.inventory.add_item(buyable[2])
			buyable[2] = UPGRADES[selected_upgrades[2]].instantiate()
			print("Purchased " + buyable[2].get_upgrade())
	PlayerVariables.coins = money

func _on_option_1_area_body_entered(body):
	In_Option_1 = true
	get_node("Upgrade_Description").text = buyable[0].get_descript()
	$Upgrade_Description.visible = true

func _on_option_2_area_body_entered(body):
	In_Option_2 = true
	get_node("Upgrade_Description").text = buyable[1].get_descript()
	$Upgrade_Description.visible = true

func _on_option_3_area_body_entered(body):
	In_Option_3 = true
	get_node("Upgrade_Description").text = buyable[2].get_descript()
	$Upgrade_Description.visible = true


func _on_option_1_area_body_exited(body):
	In_Option_1 = false
	get_node("Upgrade_Description").text = ""

func _on_option_2_area_body_exited(body):
	In_Option_2 = false
	get_node("Upgrade_Description").text = ""

func _on_option_3_area_body_exited(body):
	In_Option_3 = false
	get_node("Upgrade_Description").text = ""


func _on_exit_checker_body_exited(body):
	$Upgrade_Description.visible = false


func _on_reroll_area_body_entered(body):
	in_reroll = true
	get_node("Upgrade_Description").text = "Press 'E' to reroll the shop items!"
	$Upgrade_Description.visible = true

func _on_reroll_area_body_exited(body):
	in_reroll = false
	get_node("Upgrade_Description").text = ""
