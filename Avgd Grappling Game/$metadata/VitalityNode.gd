extends Area2D

@onready var boss = get_parent().get_node("GenericTexture")
@onready var sprite = $Sprite2D

var color = Color(2, 0, 0)
var hp = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	color.h += randf()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color.h += 0.16 * delta
	modulate = color

func on_hit(hit):
	hp -= hit.dmg
	if hp <= 0:
		if boss != null:
			boss.take_dmg()
		queue_free()

func _on_area_entered(area):
	if area.name == "MeleeAtk":
		on_hit(area)
	

