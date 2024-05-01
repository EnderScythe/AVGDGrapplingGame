extends Node2D

@onready var sprite = $Sprite2D
@onready var particles = $GPUParticles2D
@onready var player = $/root/Global.get_player()
var bullet_res = preload("res://$metadata/Projectile.tscn")
const base_offset = Vector2(0, -1200)

var velocity = Vector2.ZERO
var target_offset = Vector2.ZERO
var accl = 0
var maxspd = 0

var rotspd = 0
var color = Color(2, 0, 0)

var phase = 0
var timer = 0
var phase_pool = []
var data = []
var level = 1  # difficulty scaling coefficient, increases with time

var bullets = []

"""
phase explanation
0: idle, passively tracks player
1: preparing for attack, tracks close to player
2: suspended bullets attack
3: orbiting wheels attack
4: shuriken attack
5: converging bullets attack
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	enter_phase(0)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null: return
	
	movement(delta)
	
	graphics(delta)
	
	process_bullets(delta)
	
	phase_process(delta)
	
	position += velocity * delta
	
	level += delta
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
					data[0] = randf_range(0.25, 0.35) #- sclnum(0.2, 400)
					var shot = bullet_res.instantiate()
					add_bullet(shot, "hover", [0], Vector2(randf_range(400, 700), 0).rotated(randf_range(0, PI*2)))
					shot.velocity.y *= 0.8
					var c = Color(3, 0, 0)
					c.h += data[1]
					c.h += data.size() * 0.08 * randf_range(0.9, 1.1)
					shot.apply_color(c)
					data.append(shot)
			elif timer < 4: pass
			elif timer < 7:
				accl = 1800
				maxspd = 2400
				target_offset = Vector2.ZERO
				if data[0] < 0:
					data[0] = 0.8 #- sclnum(0.6, 300)
					if data.size() > 2:
						var shot = data[2]
						shot.data = [1, 0]
						shot.velocity = Vector2(0, -450)
						data.remove_at(2)
			else:
				while data.size() > 2:
					var shot = data[2]
					shot.data = [1, 0]
					shot.velocity = Vector2(0, -450)
					data.remove_at(2)
				enter_phase(0)
		
		3:
			var num_rings = 4
			var shots_per_wheel = 3
			if timer < 1.5:
				rotspd *= pow(0.4, delta)
			elif timer < 3.5:
				rotspd += 0.1
				data[1] -= delta
				if data[1] < 0 and data[0] < num_rings:
					data[0] += 1
					data[1] = 2/num_rings
					var ring_dist = 300 + 1500*data[0]
					var ring_spd = ring_dist/4
					var ring_rot = 1 if data[0] % 2 == 0 else -1
					var wheels_per_ring = 3 + 2*data[0]
					spawn_wheel_ring(position, wheels_per_ring, shots_per_wheel, ring_dist, ring_spd, ring_rot*PI/10, PI/8, 300, 500, 5, 15)
			elif timer < 6: # - sclnum(2, 400)
				accl = 6000
				maxspd = 3000
			else:
				enter_phase(0)
		
		4:
			if timer < 0.5:
				var v = orbital_motion(Vector2.ZERO, data[1], 0, -base_offset.y, data[0]/0.5, delta)
				position = player.position + v
			elif timer < 2:
				pass
			elif timer < 4:
				if data[2] == 0:
					data[2] = 1
					var fire_dir = position.direction_to(player.position)
					var saw_spd = 1200
					var ang_vel = PI*4 * 1 if position.x < player.position.x else -1
					var c = Color(3, 0, 0)
					c.h += randf()
					spawn_saw(position, fire_dir, saw_spd, ang_vel, c)
					accl = 6000
					maxspd = 4000
					velocity = -fire_dir * 4000
					target_offset = base_offset
			elif timer < 5:
				maxspd = 3000
			else:
				enter_phase(0)
		
		5:
			pass
		
		_:
			enter_phase(0)
	

func enter_phase(p):
	data = []
	
	match p:
		0:
			timer = -randf_range(2, 4)
			accl = 6000
			maxspd = 3000
			target_offset = base_offset
			if phase_pool == null or phase_pool == []:
				phase_pool = [2, 2, 3, 3, 4, 4]
		1:
			timer = 0.8
			accl = 24000
			maxspd = 4000
		2:
			timer = 0
			data = [0, randf()]
		3:
			timer = 0
			data = [0, 0]
			maxspd = 0
		4:
			timer = 0
			data = [randf_range(-PI, PI), [-base_offset.y, -PI/2], 0]
			target_offset = base_offset.rotated(data[0])
			# accl = 36000
		5:
			timer = 0
	
	phase = p


func process_bullets(delta):
	var remove_queue = []
	var index = 0
	while index < bullets.size():
		if !is_instance_valid(bullets[index]):
			bullets.remove_at(index)
			continue
		
		var shot = bullets[index]
		match shot.id:
			"hover": # data: mode, timer
				var mode = shot.data[0]
				if mode == 0: shot.velocity = shot.velocity.limit_length(shot.velocity.length()-80*delta)
				elif mode == 1:
					shot.velocity = shot.velocity.limit_length(shot.velocity.length()-200*delta)
					shot.data[1] += delta
					if shot.data[1] > 2:
						shot.data[0] = 2
						shot.velocity = shot.position.direction_to(player.position) * 2000
						shot.lifespan = shot.time + 8
			
			"wheel": # data: pivot, p_pivot, [p_radius, p_angle], p_rad_vel, p_rad_target, p_ang_vel, [radius, angle], rad_vel, rad_tg, ang_vel
				shot.data[0] = orbital_motion(shot.data[1], shot.data[2], shot.data[3], shot.data[4], shot.data[5], delta)
				if shot.data[2][0] == shot.data[4]:
					shot.position = orbital_motion(shot.data[0], shot.data[6], shot.data[7], shot.data[8], shot.data[9], delta)
				else:
					shot.position = shot.data[0]
			
			"seek": # data: turn_spd, fwd_accl
				var angle_diff = 0 if shot.velocity == Vector2.ZERO else shot.velocity.angle_to(player.position - shot.position)
				var sign = -1 if angle_diff < 0 else 1
				shot.velocity += shot.velocity.normalized() * shot.data[1] * delta
				shot.velocity = shot.velocity.rotated(min(shot.data[0]*delta, abs(angle_diff)) * sign)
			
			"saw": # data: timer, pivot, pivot_vel, [radius, angle], rad_vel, rad_target, base_ang_vel, max_spd
				shot.data[0] += delta
				shot.data[1] += shot.data[2] * delta
				shot.data[2] = shot.data[2].limit_length(shot.data[2].length() - 300*delta)
				shot.position = orbital_motion(shot.data[1], shot.data[3], shot.data[4], shot.data[5], shot.data[6]*shot.data[2].length()/shot.data[7], delta)
				if shot.data[0] > 3.5:
					shot.id = "seek"
					shot.data = [0.6, 600]
					shot.velocity = Vector2(randf_range(600, 800), 0).rotated(randf_range(0, PI*2))
					shot.lifespan = shot.time + 8
			"repel": # data: repel_str, split_time, split_cnt, split_vel
				shot.velocity += player.position.direction_to(shot.position) / player.position.distance_squared_to(shot.position) * shot.data[0] * delta
				if shot.time > shot.data[1]:
					for i in range(shot.data[2]):
						var split = bullet_res.instantiate()
						add_bullet(split, "", [], Vector2(data[3], 0).rotated(shot.velocity.angle() + PI*2/shot.data[2]*i), shot.position)
						split.apply_color(shot.color)
						split.fade_time = 0
					shot.fade_out_time = 0
					shot.destroy()
		
		index += 1

func add_bullet(shot, id="", data=[], vel=Vector2.ZERO, pos=position):
	shot.id = id
	shot.position = pos
	shot.velocity = vel
	shot.data = data
	bullets.append(shot)
	add_sibling(shot)

# input: array containing radius and angle, output: Vector2 for new position
func orbital_motion(pivot, data, radial_vel, radius_target, angular_vel, delta):
	data[0] = clamp(data[0] + radial_vel * delta, 0, radius_target)
	data[1] += angular_vel * delta
	return pivot + Vector2(data[0], 0).rotated(data[1])

func spawn_saw(pos, fire_dir, saw_spd, ang_vel, c):
	var vel = fire_dir * saw_spd
	# data: timer, pivot, pivot_vel, [radius, angle], rad_vel, rad_target, base_ang_vel, max_spd
	var center = bullet_res.instantiate()
	add_bullet(center, "saw", [0, position, vel, [0, 0], 0, 0, 0, saw_spd])
	center.apply_color(c)
	center.fade_time = 0.2
	var blade_length = 2
	var num_blades = 4
	var spc = 100
	for i in range(1, blade_length+1):
		c.h += randf_range(0.08, 0.12)
		for j in range(num_blades):
			var shot = bullet_res.instantiate()
			add_bullet(shot, "saw", [0, position, vel, [spc*i, PI*2*j/num_blades], 0, spc*i, ang_vel, saw_spd])
			shot.apply_color(c)
			shot.fade_time = 0.2

func spawn_wheel_ring(center, num_wheels, shots_per_wheel, ring_dist, ring_spd, ring_rot, wheel_rot, wheel_dist, wheel_spd, fade_time, lifespan):
	for i in range(num_wheels):
		var p_angle_offset = PI*2/num_wheels*i
		var c = Color(3, 0, 0)
		c.h += randf()
		for j in range(shots_per_wheel):
			var angle_offset = PI*2/shots_per_wheel*j
			var shot = bullet_res.instantiate()
			# data: pivot, p_pivot, [p_radius, p_angle], p_rad_vel, p_rad_target, p_ang_vel, [radius, angle], rad_vel, rad_tg, ang_vel
			add_bullet(shot, "wheel", [center, center, [0, p_angle_offset], ring_spd, ring_dist, ring_rot, [0, angle_offset], wheel_dist, wheel_spd, wheel_rot])
			shot.apply_color(c)
			shot.fade_time = fade_time
			shot.lifespan = lifespan

func spawn_converge_ring(center, radius, num_shots, spd, repel_f, split_cnt):
	for i in range(num_shots):
		var r = Vector2(0, radius).rotated(2*PI/num_shots*i)
		


func movement(delta):
	var target = player.position + target_offset
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
	

# returns a number that starts at ~0 and approaches n as level approaches infinity, at a rate determined by r (smaller=faster)
func sclnum(n, r):
	return n/(1+r/level)










