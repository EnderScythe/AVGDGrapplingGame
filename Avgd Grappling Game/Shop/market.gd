extends Node2D

const temp_item_res = preload("res://Items/GrappleRangeBoost.tscn") # just to test if items work
@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
var selected_upgrades = []
var possible_upgrades = ["Shield", "Shield Regen", "Shield Strength", "Grapple Range", "Grapple Launch", "Grapple Reel", "Machine Speed", "Pick Swing", "Booster Rocket", "Double Jump", "Repulsor", "Revive"]
var upgrade_descriptions = ["A shield will take some damage for you!\n\nYou can only buy ONE SHIELD, feel free to upgrade it though!",
	"Upgrade to decrease the time it takes for the shield to start recharging!",
	"Upgrade to increase the amount of [unit] the shield can take before breaking!",
	"Upgrade to increase the distance which the end of the grapple hook can travel before automatically terminating!",
	"Upgrade to increase the speed the end of the grapple hook travels!",
	"Increases the speed you move towards the end of the grapple hook after it has attached to something!",
	"Increases your base move speed!",
	"Decreases the time between pickaxe swings!",
	"Press [key] to activate a rocket propelled booster! Achive insane velocities with this bad boy!",
	"Place a pad (able to be placed in the middle of air) to jump again; the pad can be used multiple times!\n\nYou can JUMP ON THE PAD multiple times however you can only PLACE DOWN the pad ONCE.",
	"Place a bubble which creates an area which redirects enemies elsewhere (useful when trying to mine ores with monsters around)!\n\nThe bubble has a limited duration and placing a bubble consumes one instance.",
	"Place a respawn beacon in a location of your choosing. If you get destroyed, you will be reconstructed at this location after a brief period of time!\n\nONLY ONE REVIVE IS AVAILABLE PER SHOP. REVIVE IS CONSUMED WHEN PLACED."]
var In_Option_1 = false
var In_Option_2 = false
var In_Option_3 = false
func _ready():
	$Upgrade_Description.visible = false
	
	var _rng = RandomNumberGenerator.new()
	#var Has_Shield = get_parent().get_node("Player").get_node("Shield_Area").is_monitoring() # This line causes game to crash if run in market rather than rest_area
	
	# Randomly select 3 integers from the bounds [0, n_upgrades]
	while selected_upgrades.size() < 3:
		# While randomly selecting integers, check if it's already been used and re-generate if it has
		var num = randi_range(0, possible_upgrades.size()-1)
		var Selected
		if num < 3:
			# Check if it's a valid upgrade (the shields (probably going to be values 1-3) need to be double checked)
			Selected = randi_range(1, 2)
			#if Has_Shield == false:
			Selected = 0
		else:
			Selected = num
		var Already_Selected = false
		for x in selected_upgrades.size():
			if selected_upgrades[x] == Selected:
				Already_Selected = true
				pass
		if Already_Selected == false:
			selected_upgrades.append(Selected)
	
	#for x in 3:
		#print(Selected_Upgrades[x])
		#print(Possible_Upgrades[Selected_Upgrades[x]])
	selected_upgrades[0] = 3
	get_node("Option_1").text = possible_upgrades[selected_upgrades[0]]
	get_node("Option_2").text = possible_upgrades[selected_upgrades[1]]
	get_node("Option_3").text = possible_upgrades[selected_upgrades[2]]
	
	$Option_1_Area/Sprite2D.set_texture(load("res://Assets/Shop/Shop" + str(selected_upgrades[0]) + ".png"))
	$Option_2_Area/Sprite2D.set_texture(load("res://Assets/Shop/Shop" + str(selected_upgrades[1]) + ".png"))
	$Option_3_Area/Sprite2D.set_texture(load("res://Assets/Shop/Shop" + str(selected_upgrades[2]) + ".png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if In_Option_1 == true:
			var upgrade = possible_upgrades[selected_upgrades[0]]
			player.inventory.add_item(upgrade)
		if In_Option_2 == true:
			var upgrade = selected_upgrades[1]
			print("Purchased " + str(upgrade))
		if In_Option_3 == true:
			var upgrade = selected_upgrades[2]
			print("Purchased " + str(upgrade))

func _on_option_1_area_body_entered(body):
	In_Option_1 = true
	get_node("Upgrade_Description").text = upgrade_descriptions[selected_upgrades[0]]
	$Upgrade_Description.visible = true

func _on_option_2_area_body_entered(body):
	In_Option_2 = true
	get_node("Upgrade_Description").text = upgrade_descriptions[selected_upgrades[1]]
	$Upgrade_Description.visible = true

func _on_option_3_area_body_entered(body):
	In_Option_3 = true
	get_node("Upgrade_Description").text = upgrade_descriptions[selected_upgrades[2]]
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
