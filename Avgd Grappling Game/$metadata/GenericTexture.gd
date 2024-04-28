extends Node2D

@onready var sprite = $Sprite2D
@onready var player = $/root/Global.get_player()
var bullet_res = preload("res://$metadata/Emission.tscn")

var velocity = Vector2.ZERO
var yoffset = 1500
var accl = 6000
var maxspd = 3000

var rotspd = 0
var color = Color(2, 0, 0)

var phase = 0
var timer = 0

var bullets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_phase(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null: return
	
	movement(delta)
	position += velocity * delta
	
	graphics(delta)
	
	phase_process(delta)
	
	
	


func phase_process(delta):
	timer += delta
	match phase:
		0:
			if timer >= 0:
				enter_phase(1)
		1:
			if timer >= 0:
				var next = randi_range(2, 3)
				enter_phase(next)
		2:
			pass
		3:
			pass
	

func enter_phase(p):
	match p:
		0:
			timer = -randf_range(3, 6)
			accl = 6000
			maxspd = 3000
		1:
			timer = -1
			accl = 24000
			maxspd = 4000
	
	phase = p


func process_bullets(delta):
	for shot in bullets:
		pass


func movement(delta):
	var target = player.position + Vector2.UP*1200
	velocity *= pow(0.95, delta)
	velocity += position.direction_to(target) * accl * delta
	velocity *= pow(clamp(position.distance_to(target) / 800, 0, 1), delta)
	velocity = velocity.limit_length(maxspd)

func graphics(delta):
	rotspd *= pow(0.9, delta)
	rotspd += velocity.length() / 400 * (1 if velocity.x >= 0 else -1)
	rotspd = clamp(rotspd, -PI*4, PI*4)
	sprite.rotate(rotspd*delta)
	
	color.h += 0.3*delta + rotspd*0.1*delta
	if color.h >= 1: color.h = 0
	sprite.modulate = color
	







