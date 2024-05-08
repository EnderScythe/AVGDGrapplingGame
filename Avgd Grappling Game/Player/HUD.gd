extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ShieldBar.visible = PlayerVariables.has_shield
	$Shield.visible = PlayerVariables.has_shield
	change_transparancy()
	health_bar()
	$Health.text = str(ceil(PlayerVariables.health))
	$Coin.text = str(PlayerVariables.coins)
	$Ores.text = str(PlayerVariables.ores_carried)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Health.text = str(PlayerVariables.health, " / ", PlayerVariables.max_health)
	$Shield.text = str(PlayerVariables.shield_health, " / ", PlayerVariables.shield_max)
	$Coin.text = str(PlayerVariables.coins)
	$Ores.text = str(PlayerVariables.ores_carried)
	$Low_HP.visible = true
	health_bar()
	shield_bar()
	change_transparancy()

func change_transparancy():
	var alpha = 1 - float(PlayerVariables.health) / PlayerVariables.max_health
	alpha = alpha * alpha * alpha * alpha
	$Low_HP.modulate.a = alpha

func health_bar():
	var bar = $HealthBar
	var percent = (float(PlayerVariables.health) / PlayerVariables.max_health) * 100
	bar.value = percent

func shield_has():
	$ShieldBar.visible = PlayerVariables.has_shield
	$Shield.visible = PlayerVariables.has_shield

func shield_bar():
	var bar = $ShieldBar
	var percent = (float(PlayerVariables.shield_health) / PlayerVariables.shield_max) * 100
	bar.value = percent
