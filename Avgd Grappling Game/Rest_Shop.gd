extends Node2D

# Called when the node enters the scene tree for the first time.
var Selected_Upgrades = []
var Possible_Upgrades = ["Shield", "Shield Regen", "Shield Strength", "Grapple Range", "Grapple Launch", "Grapple Reel", "Machine Speed", "Pick Swing", "Booster Rocket", "Double Jump", "Repulsor", "Revive"]
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
var In_Option_1 = false
var In_Option_2 = false
var In_Option_3 = false
func _ready():
	$Upgrade_Description.visible = false
	
	var _rng = RandomNumberGenerator.new()
	var Has_Shield = get_parent().get_node("Player").get_node("Shield_Area").is_monitoring() # This line causes game to crash if run in market rather than rest_area
	print(Has_Shield)
	
	# Randomly select 3 integers from the bounds [0, n_upgrades]
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
	# Make the preload string be "res://Assets/Shop/Shop" + str(Selected_Upgrades[x]) + ".png"
	# below is just for testing
	var img1 = preload("res://Assets/Shop/Shop0.png")
	var img2 = preload("res://Assets/Shop/Shop1.png")
	var img3 = preload("res://Assets/Shop/Shop2.png")
	var img4 = preload("res://Assets/Shop/Shop3.png")
	var img5 = preload("res://Assets/Shop/Shop4.png")
	var img6 = preload("res://Assets/Shop/Shop5.png")
	var img7 = preload("res://Assets/Shop/Shop6.png")
	var img8 = preload("res://Assets/Shop/Shop7.png")
	var img9 = preload("res://Assets/Shop/Shop8.png")
	var img10 = preload("res://Assets/Shop/Shop9.png")
	var img11 = preload("res://Assets/Shop/Shop10.png")
	var img12 = preload("res://Assets/Shop/Shop11.png")
	$Option_1_Area/Sprite2D.set_texture(img10)
	$Option_2_Area/Sprite2D.set_texture(img11)
	$Option_3_Area/Sprite2D.set_texture(img12)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if In_Option_1 == true:
			var Upgrade = Possible_Upgrades[Selected_Upgrades[0]]
			print("Purchased " + Upgrade)
		if In_Option_2 == true:
			var Upgrade = Possible_Upgrades[Selected_Upgrades[1]]
			print("Purchased " + Upgrade)
		if In_Option_3 == true:
			var Upgrade = Possible_Upgrades[Selected_Upgrades[2]]
			print("Purchased " + Upgrade)


func _on_option_1_area_area_entered(area):
	In_Option_1 = true
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[0]]
	$Upgrade_Description.visible = true

func _on_option_2_area_area_entered(area):
	In_Option_2 = true
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[1]]
	$Upgrade_Description.visible = true

func _on_option_3_area_area_entered(area):
	In_Option_3 = true
	get_node("Upgrade_Description").text = Upgrade_Descriptions[Selected_Upgrades[2]]
	$Upgrade_Description.visible = true

func _on_area_2d_area_exited(area):
	$Upgrade_Description.visible = false


func _on_option_1_area_area_exited(area):
	In_Option_1 = false
	get_node("Upgrade_Description").text = ""

func _on_option_2_area_area_exited(area):
	In_Option_2 = false
	get_node("Upgrade_Description").text = ""

func _on_option_3_area_area_exited(area):
	In_Option_3 = false
	get_node("Upgrade_Description").text = ""
