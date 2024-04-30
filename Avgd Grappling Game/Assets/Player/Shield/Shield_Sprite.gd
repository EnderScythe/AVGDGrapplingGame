extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = PlayerVariables.has_shield
	modulate.a = .333

func trigger_shield_sprite():
	visible = !PlayerVariables.shield_broken
