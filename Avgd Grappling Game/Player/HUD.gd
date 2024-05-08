extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	change_transparancy()
	health_bar()
	get_parent().get_node("Health").text = str(ceil(PlayerVariables.health))
	get_parent().get_node("Coin").text = "Coin: " + str(PlayerVariables.coins)
	get_parent().get_node("Ores").text = "Ores: " + str(PlayerVariables.ores_carried)

func Health_Changed():
	change_transparancy()
	health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().get_node("Health").text = str(ceil(PlayerVariables.health), " / ", PlayerVariables.max_health)
	get_parent().get_node("Coin").text = "Coin: " + str(floor(PlayerVariables.coins))
	get_parent().get_node("Ores").text = "Ores: " + str(floor(PlayerVariables.ores_carried))

func change_transparancy():
	var alpha = 1 - float(PlayerVariables.health) / PlayerVariables.max_health
	alpha = alpha * alpha * alpha * alpha
	print(alpha)
	get_parent().get_node("Low_HP").modulate.a = alpha

func health_bar():
	var bar = get_parent().get_node("HealthBar")
	var percent = (float(PlayerVariables.health) / PlayerVariables.max_health) * 100
	#print("percent")
	bar.value = percent
