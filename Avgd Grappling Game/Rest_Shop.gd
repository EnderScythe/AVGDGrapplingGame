extends Node2D


# Called when the node enters the scene tree for the first time.
var Selected_Upgrades = []
func _ready():
	$Upgrade_Description.visible = false
	
	var _rng = RandomNumberGenerator.new()
	var Has_Shield = get_parent().get_node("Player").get_node("Shield_Area").is_monitoring() # This line causes game to crash if run in market rather than rest_area
	print(Has_Shield)
	# Create an array with all of the possible upgrades
	var Possible_Upgrades = ["Shield", "Shield Regen", "Shield Strength", "Grapple Range", "Grapple Launch", "Grapple Reel", "Machine Speed", "Pick Swing Speed", "Booster Rocket", "Double Jump", "Repulsor", "Revive"]
	
	# Randomly select 3 integers from the bounds [0, array.size()]
	while Selected_Upgrades.size() < 3:
		# While randomly selecting integers, check if it's already been used and re-generate if it has
		var num = randi_range(0, Possible_Upgrades.size()-1)
		var Selected
		if num < 3:
			# Check if it's a valid upgrade (the shields (probably going to be values 1-3) need to be double checked)
			Selected = randi_range(1, 2)
			if Has_Shield == false:
				Selected = 0
		else:
			Selected = num
		var Already_Selected = false
		for x in Selected_Upgrades.size():
			if Selected_Upgrades[x] == Selected:
				Already_Selected = true
				pass
		if Already_Selected == false:
			Selected_Upgrades.append(Selected)
	
	#for x in 3:
		#print(Selected_Upgrades[x])
		#print(Possible_Upgrades[Selected_Upgrades[x]])
	get_node("Option_1").text = Possible_Upgrades[Selected_Upgrades[0]]
	get_node("Option_2").text = Possible_Upgrades[Selected_Upgrades[1]]
	get_node("Option_3").text = Possible_Upgrades[Selected_Upgrades[2]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var Upgrade_Descriptions = ["A shield will take some damage for you!\n\nYou can only buy ONE SHIELD, feel free to upgrade it though!",
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
func _on_option_1_area_area_entered(area):
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[0]]
	$Upgrade_Description.visible = true

func _on_option_2_area_area_entered(area):
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[1]]
	$Upgrade_Description.visible = true

func _on_option_3_area_area_entered(area):
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[2]]
	$Upgrade_Description.visible = true

func _on_area_2d_area_exited(area):
	$Upgrade_Description.visible = false
