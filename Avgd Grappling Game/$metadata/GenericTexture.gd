extends Node2D

@onready var sprite = $Sprite2D
@onready var particles = $GPUParticles2D
@onready var player = $/root/Global.get_player()
var bullet_res = preload("res://$metadata/Projectile.tscn")

var velocity = Vector2.ZERO
var yoffset = 1500
var accl = 6000
var maxspd = 3000

var rotspd = 0
var color = Color(2, 0, 0)

var phase = 0
var timer = 0
var phase_pool = []
var data = []

var bullets = []

"""
phase explanation
0: idle, passively tracks player
1: preparing for attack, tracks close to player
2: suspended bullets attack
3: orbiting wheels attack
4: enclosing bullets attack
"""

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
	
	process_bullets(delta)
	
	$"/root/PlayerVariables".ores_carried += delta # rudimentary score system
	


func phase_process(delta):
	timer += delta
	match phase:
		0:
			if timer >= 0:
				enter_phase(1)
		1:
			if timer >= 0:
				var i = randi_range(0, phase_pool.size()-1)
				var next = phase_pool[i]
				phase_pool.remove_at(i)
				enter_phase(next)
		2:
			data[0] -= delta
			if timer < 3:
				if data[0] < 0:
					data[0] = randf_range(0.25, 0.35)
					var shot = bullet_res.instantiate()
					add_bullet(shot, "hover", [0], Vector2(randf_range(400, 700), 0).rotated(randf_range(0, PI*2)))
					shot.velocity.y *= 0.8
					var c = [Color.RED, Color.YELLOW, Color.GREEN, Color.AQUA, Color.BLUE, Color.PURPLE]
					var i = (data.size() - 1) % c.size()
					shot.apply_color(c[i], 1, 6)
					data.append(shot)
			elif timer < 3.5: pass
			elif timer < 16:
				if position.y < player.position.y:
					velocity += Vector2(0, 4000*delta)
					accl = 2000
				else:
					accl = 4000
				if data[0] < 0:
					data[0] = 1.2
					if data.size() > 1:
						var shot = data[1]
						shot.data = [1, 0]
						shot.velocity = Vector2(0, -360)
						data.remove_at(1)
			else:
				while data.size() > 1:
					var shot = data[1]
					shot.data = [2, 0]
					data.remove_at(1)
				enter_phase(0)
		3:
			pass
		4:
			pass
		_:
			enter_phase(0)
	

func enter_phase(p):
	data = []
	
	match p:
		0:
			timer = -randf_range(3, 6)
			accl = 6000
			maxspd = 3000
			if phase_pool == null or phase_pool == []:
				phase_pool = [2] # [2, 2, 3, 3, 4, 4]
		1:
			timer = -1
			accl = 24000
			maxspd = 4000
		2:
			timer = 0
			data = [0]
		3:
			timer = 0
		4:
			timer = 0
	
	phase = p


func process_bullets(delta):
	var remove_queue = []
	for shot in bullets:
		if shot == null or !is_instance_valid(shot):
			remove_queue.append(shot)
			continue
		match shot.id:
			"hover":
				var mode = shot.data[0]
				if mode == 0: shot.velocity = shot.velocity.limit_length(shot.velocity.length()-80*delta)
				elif mode == 1:
					shot.velocity = shot.velocity.limit_length(shot.velocity.length()-160*delta)
					shot.data[1] += delta
					if shot.data[1] > 2:
						shot.data[0] = 2
						shot.velocity = shot.position.direction_to(player.position) * 2000
						shot.lifespan = shot.time + 8
			"wheel":
				pass
	for item in remove_queue:
		bullets.erase(item)

func add_bullet(shot, id="", data=[], vel=Vector2.ZERO, pos=position):
	shot.id = id
	shot.position = pos
	shot.velocity = vel
	shot.data = data
	bullets.append(shot)
	add_sibling(shot)


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
	
	particles.process_material.color = color
	particles.process_material.color.a = 0.5
	
	particles.process_material.orbit_velocity_max = abs(rotspd) / PI / 3
	particles.process_material.orbit_velocity_min = 0.8
	







