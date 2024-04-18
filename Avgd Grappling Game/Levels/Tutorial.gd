extends Node2D

var time = 0
var entered_phase3 = -1
var phase = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Phase_0/Text.visible = false
	$Player.visible = false
	$Phase_0/Sprite2D.visible = true
	$Phase_1/Lore.visible = false
	$Phase_1/Move.visible = false
	$Phase_2/Grapple_Text.visible = false
	$Phase_3/Ore_Depot.visible = false
	$Phase_3/Right_Click.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if phase == 0:
		phase_zero()
	if phase == 1:
		phase_one()
	if phase == 2:
		phase_two()
		entered_phase3 = time
	if phase == 3:
		phase_three()
	

func phase_zero():
	$Phase_0/Text.visible = true
	if time < 1.5: $"Phase_0/Text".text = "initializing..."
	elif time < 3 && time > 1.5: $"Phase_0/Text".text = "visualizing..."
	else:
		$"Phase_0/Text".visible = false
		$"Phase_0/Sprite2D".visible = false
		$"Player".visible = true
		phase = 1
		$"Phase_0/Blocker".queue_free()

func phase_one():
	$Phase_1/Lore.text = "[system] you are an autonomous excavator. your sole purpose is to mine and deliver ores. this is a test set up by [redacted] to assess different scenarios."
	$Phase_1/Lore.visible = true
	if time > 7.5:
		$Phase_1/Move.visible = true

func phase_two():
	$Phase_2/Grapple_Text.visible = true

func phase_three():
	$Phase_3/Ore_Depot.visible = true
	if time > entered_phase3 + 1.5:
		$Phase_3/Right_Click.visible = true


func _on_grapple_help_body_entered(body):
	phase = 2


func _on_progress_body_entered(body):
	phase = 3
