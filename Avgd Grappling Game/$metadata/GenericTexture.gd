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

var level = 1  # difficulty scaling coefficient, increases with time -- considering deleting/replacing with different difficulty scaling mechanic
var health = 4

var bullets = []

"""
phase explanation
0: idle, passively tracks player
1: preparing for attack, tracks close to player
2: suspended bullets attack
3: orbiting wheels attack
4: shuriken attack
5: converging bullets attack
6: revolving door attack
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
	
	


func phase_process(delta):
	timer += delta
	match phase:
		-1: # death
			if timer < 0:
				rotspd += PI*delta
				data[1] -= delta
				if data[1] < 0:
					data[1] = data[0]
					data[0] *= 0.83
					var vel = randf_range(600, 1200)
					var dir = randf_range(0, PI*2)
					var c = Color(3, 0, 0)
					c.h += randf()
					var shot = bullet_res.instantiate()
					add_bullet(shot, "", [], Vector2(vel, 0).rotated(dir))
					shot.apply_color(c)
					shot.fade_time = 0
					shot.fade_out_time = 8
					shot.lifespan = 0
			else:
				var count = 24
				var c = Color(3, 0, 0)
				c.h += randf()
				for i in range(count):
					var vel = 800
					var dir = PI*2/count*i
					var shot = bullet_res.instantiate()
					c.h += 1.0/count
					add_bullet(shot, "", [], Vector2(vel, 0).rotated(dir))
					shot.apply_color(c)
					shot.fade_time = 0
					shot.fade_out_time = 8
					shot.lifespan = 0
				queue_free()
		0: # passive
			if timer >= 0:
				enter_phase(1)
		
		1: # tracking
			if timer >= 0:
				var i = randi_range(0, phase_pool.size()-1)
				var next = phase_pool[i]
				phase_pool.remove_at(i)
				enter_phase(next)
		
		2: # hover
			data[0] -= delta
			if timer < 3:
				if data[0] < 0:
					data[0] = randf_range(0.25, 0.35) #- sclnum(0.2, 400)
					var shot = bullet_res.instantiate()
					add_bullet(shot, "hover", [0], Vector2(randf_range(400, 800), 0).rotated(randf_range(0, PI*2)))
					shot.velocity.y *= 0.8
					var c = Color(3, 0, 0)
					c.h += data[1]
					c.h += data.size() * 0.08 * randf_range(0.9, 1.1)
					shot.apply_color(c)
					data.append(shot)
			elif timer < 3.5: pass
			elif timer < 6:
				accl = 1600
				maxspd = 2400
				target_offset = Vector2.ZERO
				if data[0] < 0:
					data[0] = 0.6 #- sclnum(0.45, 300)
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
		
		3: # wheel ring
			var num_rings = 4
			var shots_per_wheel = 3
			if timer < 1.5:
				rotspd *= pow(0.4, delta)
			elif timer < 3.5:
				rotspd += PI*2 * delta
				data[1] -= delta
				if data[1] < 0 and data[0] < num_rings:
					data[0] += 1
					data[1] = 2/num_rings
					var ring_dist = 300 + 1500*data[0]
					var ring_spd = ring_dist/4
					var ring_rot = 1 if data[0] % 2 == 0 else -1
					var wheels_per_ring = 3 + 2*data[0]
					spawn_wheel_ring(position, wheels_per_ring, shots_per_wheel, ring_dist, ring_spd, ring_rot*PI/10, PI/8, 300, 500, 5, 15)
			elif timer < 4:
				accl = 6000
				maxspd = 3000
			else:
				enter_phase(0)
		
		4: # shuriken
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
					var spd_decay = 300
					var ang_vel = PI*6 * 1 if position.x < player.position.x else -1
					spawn_saw(position, fire_dir*saw_spd, 2, 4, spd_decay, ang_vel, 3.5)
					accl = 6000
					maxspd = 4000
					velocity = -fire_dir * 4000
					target_offset = base_offset
			elif timer < 4.5:
				maxspd = 3000
			else:
				enter_phase(0)
		
		5: # converge repel
			if timer < 3:
				data[1] -= delta
				if data[0] < 3 and data[1] < 0:
					# spawn_converge_ring(center, radius, num_shots, shot_vel, repel_f, time, split_cnt, split_vel)
					spawn_converge_ring(player.position, 1600+200*data[0], 12+4*data[0], 800+100*data[0], 400000, 4.5, 3+data[0]*2, 800)
					data[0] += 1
					data[1] = 0.8
			elif timer < 4:
				if data[0] != 0:
					target_offset.x += randf_range(-600, 600)
					target_offset.y += randf_range(0, 300)
					data[0] = 0
					data[1] = 0
			elif timer < 4.5:
				data[1] -= delta
				if data[0] < 3 and data[1] < 0:
					var dir = position.direction_to(player.position)
					var spread = PI/3 + PI/6*data[0]
					var ang_vel = PI*4 * 1 if position.x < player.position.x else -1
					spawn_saw(position, dir.rotated(randf_range(-spread, spread))*randf_range(600, 800), 1, 3, 300, ang_vel, 3)
					data[0] += 1
					data[1] = 0.1
			else:
				enter_phase(0)
		
		6: # revolving door
			if timer < 0.8:
				rotspd += PI*2 * data[1] * delta
			if timer < 2:
				if data[0] == 0:
					maxspd = 3000
					var radius = 2400
					var spc = 100
					var gap_size = 8
					var rot_dir = data[1]
					var duration = 10
					spawn_wall_ring(position, radius, 30, -PI/4*rot_dir, 1, duration)
					spawn_saw_gaps(position, ceil(radius/spc), 4, PI/6*rot_dir, duration, gap_size)
					data[0] = 1
			elif timer < 3:
				accl = 6000
			else:
				enter_phase(0)
		
		_:
			enter_phase(0)
	

func enter_phase(p):
	data = []
	
	match p:
		-1:
			timer = -8
			data = [1, 0]
			maxspd = 0
			rotspd = 0
			for shot in bullets:
				if is_instance_valid(shot):
					shot.destroy()
		0:
			timer = -randf_range(1, 3)
			accl = 6000
			maxspd = 3000
			target_offset = base_offset
			if phase_pool == null or phase_pool == []:
				phase_pool = [2, 3, 4, 5, 6]
		1:
			timer = -0.8
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
		5:
			timer = 0
			data = [0, 0]
			accl = 6000
		6:
			timer = 0
			data = [0, 1 if randf() < 0.5 else -1]
			accl = 6000
			maxspd = 0
	
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
						shot.velocity = shot.position.direction_to(player.position) * 1800
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
			
			"saw": # data: timer, pivot, pivot_vel, [radius, angle], rad_vel, rad_target, ang_vel, ang_decay, spd_decay, lifespan, enable_split
				shot.data[0] += delta
				shot.data[1] += shot.data[2] * delta
				shot.data[2] = shot.data[2].limit_length(shot.data[2].length() - shot.data[8]*delta)
				shot.data[6] = (-1 if shot.data[6] < 0 else 1) * max(abs(shot.data[6]) - shot.data[7] * delta, 0)
				shot.position = orbital_motion(shot.data[1], shot.data[3], shot.data[4], shot.data[5], shot.data[6], delta)
				if shot.data[0] > shot.data[9]:
					if shot.data[10]:
						shot.id = "seek"
						shot.data = [0.5, 600]
						shot.velocity = Vector2(randf_range(500, 700), 0).rotated(randf_range(0, PI*2))
						shot.lifespan = shot.time + 8
					else:
						shot.destroy()
			
			"repel": # data: repel_str, split_time, split_cnt, split_vel
				shot.velocity += player.position.direction_to(shot.position) / player.position.distance_to(shot.position) * shot.data[0] * delta
				if shot.time > shot.data[1]:
					for i in range(shot.data[2]):
						var split = bullet_res.instantiate()
						add_bullet(split, "", [], Vector2(shot.data[3], 0).rotated(shot.velocity.angle() + PI*2/shot.data[2]*i), shot.position)
						split.apply_color(shot.color)
						split.fade_time = 0
						split.lifespan = 6
						split.scale *= 0.5
					shot.fade_out_time = 0
					shot.destroy()
			
			"wall": # data: pivot, [radius, angle], ang_vel, split_cd, cur_split_cd, split_vel
				shot.position = orbital_motion(shot.data[0], shot.data[1], 0, shot.data[1][0], shot.data[2], delta)
				shot.data[4] -= delta
				if shot.data[4] < 0:
					shot.data[4] = shot.data[3]
					var split = bullet_res.instantiate()
					add_bullet(split, "", [], shot.data[0].direction_to(shot.position)*shot.data[5], shot.position)
					split.apply_color(shot.color)
					split.fade_time = 0
					split.lifespan = 3
					split.scale *= 0.5
					split.hurtbox.kb_scale = null
			
		
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

func spawn_saw(pos, vel, blade_length, num_blades, spd_decay, ang_vel, lifespan, enable_split=true, fade_time=0.2, spc=100):
	# data: timer, pivot, pivot_vel, [radius, angle], rad_vel, rad_target, base_ang_vel, max_spd, spd_decay
	var center = bullet_res.instantiate()
	add_bullet(center, "saw", [0, position, vel, [0, 0], 0, 0, 0, 0, spd_decay, lifespan, enable_split])
	var c = Color(3, 0, 0)
	c.h += randf()
	center.apply_color(c)
	center.fade_time = fade_time
	for i in range(1, blade_length+1):
		c.h += randf_range(0.08, 0.12)
		for j in range(num_blades):
			var shot = bullet_res.instantiate()
			add_bullet(shot, "saw", [0, position, vel, [spc*i, PI*2*j/num_blades], 0, spc*i, ang_vel, 0 if vel.length() == 0 else ang_vel*spd_decay/vel.length(), spd_decay, lifespan, enable_split])
			shot.apply_color(c)
			shot.fade_time = fade_time

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

func spawn_converge_ring(center, radius, num_shots, shot_vel, repel_f, time, split_cnt, split_vel):
	var c = Color(3, 0, 0)
	c.h += randf()
	for i in range(num_shots):
		c.h += 1.0/num_shots
		var r = Vector2(0, -radius).rotated(2*PI/num_shots*i)
		var shot = bullet_res.instantiate()
		# repel_str, split_time, split_cnt, split_vel
		add_bullet(shot, "repel", [repel_f, time, split_cnt, split_vel], -r.normalized()*shot_vel, center+r)
		shot.apply_color(c)

func spawn_wall_ring(center, radius, num_shots, ang_vel, fade_time, lifespan):
	var c = Color(3, 0, 0)
	c.h += randf()
	for i in range(num_shots):
		c.h += 2.0/num_shots
		var angle = 2*PI/num_shots*i
		var r = Vector2(0, radius).rotated(angle)
		var shot = bullet_res.instantiate()
		# data: pivot, [radius, angle], ang_vel, split_cd, cur_split_cd, split_vel
		add_bullet(shot, "wall", [center, [radius, angle], ang_vel, 0.2, fade_time, 1800], Vector2.ZERO, center+r)
		shot.apply_color(c)
		shot.fade_time = fade_time
		shot.lifespan = lifespan

func spawn_saw_gaps(pos, blade_length, num_blades, ang_vel, lifespan, gap_size, fade_time=1.5, spc=100):
	# data: timer, pivot, pivot_vel, [radius, angle], rad_vel, rad_target, base_ang_vel, ang_decay, spd_decay, lifespan, enable_split
	var center = bullet_res.instantiate()
	add_bullet(center, "saw", [0, position, Vector2.ZERO, [0, 0], 0, 0, 0, 0, 0, lifespan, false])
	var c = Color(3, 0, 0)
	c.h += randf()
	center.apply_color(c)
	center.fade_time = fade_time
	if gap_size >= blade_length: return
	var gap_pos = []
	for i in range(num_blades):
		gap_pos.append(randi_range(0, blade_length-gap_size))
	for i in range(1, blade_length+1):
		c.h += randf_range(0.08, 0.12)
		for j in range(num_blades):
			if i >= gap_pos[j] and i <= gap_pos[j]+gap_size: continue
			var shot = bullet_res.instantiate()
			add_bullet(shot, "saw", [0, position, Vector2.ZERO, [spc*i, PI*2*j/num_blades], 0, spc*i, ang_vel, 0, 0, lifespan, false])
			shot.apply_color(c)
			shot.fade_time = fade_time


func take_dmg(dmg=1):
	health -= dmg
	if health <= 0:
		enter_phase(-1)
		PlayerVariables.ores_carried += 1000

# returns a number that starts at ~0 and approaches n as level approaches infinity, at a rate determined by r (smaller=faster)
func sclnum(n, r):
	return n/(1+r/level)



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
	











