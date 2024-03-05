extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ShieldUpgrades/ShieldRecharge").disabled = true
	get_node("ShieldUpgrades/ShieldStrength").disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_shield_pressed():
	get_node("ShieldUpgrades/Shield").disabled = true
	print("Bought a shield!")
	get_node("ShieldUpgrades/ShieldRecharge").disabled = false
	get_node("ShieldUpgrades/ShieldStrength").disabled = false
func _on_shield_mouse_entered():
	get_node("UpgradeDescription").text = "A shield will take some damage for you!\n\nYou can only buy ONE SHIELD, feel free to upgrade it though!"
func _on_shield_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_shield_recharge_pressed():
	print("Shield recharge speed increased!")
func _on_shield_recharge_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to decrease the time it takes for the shield to start recharging!"
func _on_shield_recharge_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_shield_strength_pressed():
	print("Shield strength increased!")
func _on_shield_strength_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the amount of [unit] the shield can take before breaking!"
func _on_shield_strength_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_range_pressed():
	print("Grapple range increased!")
func _on_grapple_range_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the distance which the end of the grapple hook can travel before automatically terminating!"
func _on_grapple_range_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_launch_pressed():
	print("Grapple launch speed increased!")
func _on_grapple_launch_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the speed the end of the grapple hook travels!"
func _on_grapple_launch_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_reel_pressed():
	print("Grapple reel-in speed increased!")
func _on_grapple_reel_mouse_entered():
	get_node("UpgradeDescription").text = "Increases the speed you move towards the end of the grapple hook after it has attached to something!"
func _on_grapple_reel_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_machine_speed_pressed():
	print("Increased your move speed!")
func _on_machine_speed_mouse_entered():
	get_node("UpgradeDescription").text = "Increases your base move speed!"
func _on_machine_speed_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_pick_swing_speed_pressed():
	print("Increased swing speed!")
func _on_pick_swing_speed_mouse_entered():
	get_node("UpgradeDescription").text = "Decreases the time between pickaxe swings"
func _on_pick_swing_speed_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_booster_rocket_pressed():
	print("Mounted rockets onto machine!")
func _on_booster_rocket_mouse_entered():
	get_node("UpgradeDescription").text = "Press [key] to activate a rocket propelled booster! Achive insane velocities with this bad boy!"
func _on_booster_rocket_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_double_jump_pressed():
	print("Purchased a double jump!")
func _on_double_jump_mouse_entered():
	get_node("UpgradeDescription").text = "Place a pad (able to be placed in the middle of air) to jump again; the pad can be used multiple times!\n\nYou can JUMP ON THE PAD multiple times however you can only PLACE DOWN the pad ONCE."
func _on_double_jump_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_repulsor_pressed():
	print("Purchased a repulsor!")
func _on_repulsor_mouse_entered():
	get_node("UpgradeDescription").text = "Place a bubble which creates an area which redirects enemies elsewhere (useful when trying to mine ores with monsters around)!\n\nThe bubble has a limited duration and placing a bubble consumes one instance."
func _on_repulsor_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_revive_pressed():
	print("Purchased a revive!")
	get_node("Items/Revive").disabled = true
func _on_revive_mouse_entered():
	get_node("UpgradeDescription").text = "Place a respawn beacon in a location of your choosing. If you get destroyed, you will be reconstructed at this location after a brief period of time!\n\nONLY ONE REVIVE IS AVAILABLE PER SHOP. REVIVE IS CONSUMED WHEN PLACED."
func _on_revive_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."
