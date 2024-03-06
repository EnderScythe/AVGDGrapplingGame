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
	get_node("PurchaseHistory").text += "+ Shield\n"
	get_node("ShieldUpgrades/ShieldRecharge").disabled = false
	get_node("ShieldUpgrades/ShieldStrength").disabled = false
func _on_shield_mouse_entered():
	get_node("UpgradeDescription").text = "A shield will take some damage for you!\n\nYou can only buy ONE SHIELD, feel free to upgrade it though!"
func _on_shield_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_shield_recharge_pressed():
	get_node("PurchaseHistory").text += "+ Recharge Speed\n"
func _on_shield_recharge_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to decrease the time it takes for the shield to start recharging!"
func _on_shield_recharge_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_shield_strength_pressed():
	get_node("PurchaseHistory").text += "+ Shield strength\n"
func _on_shield_strength_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the amount of [unit] the shield can take before breaking!"
func _on_shield_strength_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_range_pressed():
	get_node("PurchaseHistory").text += "+ Range\n"
func _on_grapple_range_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the distance which the end of the grapple hook can travel before automatically terminating!"
func _on_grapple_range_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_launch_pressed():
	get_node("PurchaseHistory").text += "+ Launch speed\n"
func _on_grapple_launch_mouse_entered():
	get_node("UpgradeDescription").text = "Upgrade to increase the speed the end of the grapple hook travels!"
func _on_grapple_launch_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_grapple_reel_pressed():
	get_node("PurchaseHistory").text += "+ Reel-in speed\n"
func _on_grapple_reel_mouse_entered():
	get_node("UpgradeDescription").text = "Increases the speed you move towards the end of the grapple hook after it has attached to something!"
func _on_grapple_reel_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_machine_speed_pressed():
	get_node("PurchaseHistory").text += "+ Move speed\n"
func _on_machine_speed_mouse_entered():
	get_node("UpgradeDescription").text = "Increases your base move speed!"
func _on_machine_speed_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_pick_swing_speed_pressed():
	get_node("PurchaseHistory").text += "+ Swing speed\n"
func _on_pick_swing_speed_mouse_entered():
	get_node("UpgradeDescription").text = "Decreases the time between pickaxe swings!"
func _on_pick_swing_speed_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_booster_rocket_pressed():
	get_node("PurchaseHistory").text += "+ Rockets\n"
func _on_booster_rocket_mouse_entered():
	get_node("UpgradeDescription").text = "Press [key] to activate a rocket propelled booster! Achive insane velocities with this bad boy!"
func _on_booster_rocket_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_double_jump_pressed():
	get_node("PurchaseHistory").text += "+ Double jump\n"
func _on_double_jump_mouse_entered():
	get_node("UpgradeDescription").text = "Place a pad (able to be placed in the middle of air) to jump again; the pad can be used multiple times!\n\nYou can JUMP ON THE PAD multiple times however you can only PLACE DOWN the pad ONCE."
func _on_double_jump_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_repulsor_pressed():
	get_node("PurchaseHistory").text += "+ Repulsor\n"
func _on_repulsor_mouse_entered():
	get_node("UpgradeDescription").text = "Place a bubble which creates an area which redirects enemies elsewhere (useful when trying to mine ores with monsters around)!\n\nThe bubble has a limited duration and placing a bubble consumes one instance."
func _on_repulsor_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."

func _on_revive_pressed():
	get_node("PurchaseHistory").text += "+ Revive\n"
	get_node("Items/Revive").disabled = true
func _on_revive_mouse_entered():
	get_node("UpgradeDescription").text = "Place a respawn beacon in a location of your choosing. If you get destroyed, you will be reconstructed at this location after a brief period of time!\n\nONLY ONE REVIVE IS AVAILABLE PER SHOP. REVIVE IS CONSUMED WHEN PLACED."
func _on_revive_mouse_exited():
	get_node("UpgradeDescription").text = "Hover over a button to expand."
