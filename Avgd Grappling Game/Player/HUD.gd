extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Shield_Bar.visible = PlayerVariables.has_shield
	$ShieldBar.visible = PlayerVariables.has_shield
	change_transparancy()
	health_bar()
	get_node("Health").text = str(ceil(PlayerVariables.health))
	get_node("Coin").text = "Coin: " + str(PlayerVariables.coins)
	get_node("Ores").text = "Ores: " + str(PlayerVariables.ores_carried)

func Health_Changed():
	change_transparancy()
	health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("Health").text = str(ceil(PlayerVariables.health), " / ", PlayerVariables.max_health)
	get_node("Coin").text = str(PlayerVariables.coins)
	get_node("Ores").text = str(PlayerVariables.ores_carried)
	health_bar()
	shield_bar()
	change_transparancy()

func change_transparancy():
	var alpha = 1 - float(PlayerVariables.health) / PlayerVariables.max_health
	alpha = alpha * alpha * alpha * alpha
	print(alpha)
	get_node("Low_HP").modulate.a = alpha

func health_bar():
	var bar = get_node("HealthBar")
	var percent = (float(PlayerVariables.health) / PlayerVariables.max_health) * 100
	bar.value = percent

func shield_has():
	$Shield_Bar.visible = PlayerVariables.has_shield
	$ShieldBar.visible = PlayerVariables.has_shield

func shield_bar():
	var bar = get_node("ShieldBar")
	var percent = (float(PlayerVariables.shield_health) / PlayerVariables.shield_max) * 100
	bar.value = percent
