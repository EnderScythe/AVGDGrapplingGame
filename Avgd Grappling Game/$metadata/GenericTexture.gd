extends Node2D

@onready var sprite = $Sprite2D
@onready var player = $/root/Global.get_player()

var yoffset = 1500
var velocity = Vector2.ZERO
var accl = 6000
var maxspd = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null: return
	var target = player.position + Vector2.UP*1200
	
	velocity *= pow(0.95, delta)
	velocity += position.direction_to(target) * accl * delta
	velocity *= pow(clamp(position.distance_to(target) / 800, 0, 1), delta)
	velocity = velocity.limit_length(maxspd)
	
	position += velocity * delta
	
	




