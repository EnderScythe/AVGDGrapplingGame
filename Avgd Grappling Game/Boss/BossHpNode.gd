extends Area2D

@onready var boss = get_parent().get_node("PrismBoss")
@onready var sprite = $Sprite2D

var color = Color(2, 0, 0)
var hp = 30
var active = true
var decolor_time = 0.6
var decolor_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	color.h += randf()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss == null:
		queue_free()
		return
	
	if !has_user_signal("activate_hp_nodes"):
		boss.connect("activate_hp_nodes", func():activate())
	
	if decolor_timer > 0:
		decolor_timer -= delta
	else:
		decolor_timer = 0
	
	if active:
		color.h += 0.16 * delta
		modulate = color.lerp(Color(0.3, 0.3, 0.3), decolor_timer/decolor_time)
	else:
		modulate = color.lerp(Color(0.3, 0.3, 0.3), 1-decolor_timer/decolor_time)

func on_hit(hit):
	if !active: return
	hp -= hit.dmg
	if hp <= 0:
		PlayerVariables.ores_carried += 50
		deactivate()
		if boss != null:
			boss.take_dmg()

func activate():
	active = true
	decolor_timer = decolor_time
	hp = 30

func deactivate():
	active = false
	decolor_timer = decolor_time

func _on_area_entered(area):
	if area.name == "MeleeAtk":
		on_hit(area)
	

