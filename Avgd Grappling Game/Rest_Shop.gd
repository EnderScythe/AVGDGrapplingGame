extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var _rng = RandomNumberGenerator.new()
	var Has_Shield = get_parent().get_node("Player").get_node("Shield_Area").is_monitoring() # This line causes game to crash if run in market rather than rest_area
	print(Has_Shield)
	# Create an array with all of the possible upgrades
	var Possible_Upgrades = ["Shield", "Shield Regen", "Shield Strength", "Grapple Range", "Grapple Launch", "Grapple Reel", "Machine Speed", "Pick Swing Speed", "Booster Rocket", "Double Jump", "Repulsor", "Revive"]
	var Selected_Upgrades = []
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
	
	for x in 3:
		print(Selected_Upgrades[x])
		print(Possible_Upgrades[Selected_Upgrades[x]])
	get_node("Option_1").text = Possible_Upgrades[Selected_Upgrades[0]]
	get_node("Option_2").text = Possible_Upgrades[Selected_Upgrades[1]]
	get_node("Option_3").text = Possible_Upgrades[Selected_Upgrades[2]]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
