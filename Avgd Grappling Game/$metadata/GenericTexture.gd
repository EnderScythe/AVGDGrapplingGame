extends Node2D

@onready var sprite = $Sprite2D
@onready var player = $/root/Global.get_player()

var yoffset = 1500
var velocity = Vector2.ZERO
var accl = 6000
var maxspd = 3000

var rotspd = 0
var color = Color(1, 1, 0)

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
	
	
	rotspd *= pow(0.9, delta)
	rotspd += velocity.length() / 400 * (1 if velocity.x >= 0 else -1)
	rotspd = clamp(rotspd, -PI*4, PI*4)
	
	sprite.rotate(rotspd*delta)
	
	
	color.h += 0.3*delta + rotspd*0.1*delta
	if color.h >= 1: color.h = 0
	sprite.modulate = color
	
	
	









