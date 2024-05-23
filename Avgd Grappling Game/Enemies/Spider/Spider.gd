extends CharacterBody2D

# Spider Statistics

var maxSpeed = 400
var acceleration = 20
@onready var health = $HpComponent

var currentPos = 0
var targetPos = 0
var offsetFromGround = 0

var movingLeft = true
var spiderShootOnce = false
var spiderState = "wander"

# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var random = RandomNumberGenerator.new();
const venom = preload("res://Enemies/Spider/venom.tscn")

func _ready():
	currentPos = position
	targetPos = position

func _physics_process(delta):
	var playerPosition = get_parent().get_node("Player").position
	#get_tree().current_scene.get_node("TileMap").deal_enemy_damage(position, self, delta)
	var tilemap = get_tree().current_scene.get_node("TileMap")
	#if get_tree().current_scene.name != "TestRoom":
	tilemap.deal_enemy_damage(position, self, delta)
	#if !$l_ray.is_colliding():
		#spiderState = "chase"
	
	if not is_on_floor() and not is_on_ceiling() and rotation_degrees != -180:
		velocity.y += gravity * delta
	
	# Wander State: Random Movement
	if (spiderState == "wander"):
		movement()
	
	# Climb State: Climbs up the wall
	
	elif (spiderState == "climb"):
		wallClimb()
		print(offsetFromGround)
	
	# Chase State: Follow the player
	
	elif (spiderState == "chase"):
		adjustOffset()
		
		$AnimatedSprite2D.play("walk")
		targetPos = playerPosition
		
		var currentAcc = position.direction_to(targetPos) * acceleration
		velocity += currentAcc
		currentPos = position
		
		if (velocity.x > 0):
			$".".scale.x =  scale.y * -1
		elif (velocity.x < 0):
			$".".scale.x =  scale.y * 1
		
		if (velocity.x > maxSpeed):
			velocity.x = maxSpeed
		elif (velocity.x < -maxSpeed):
			velocity.x = -maxSpeed
		
		if ($VenomTimer.time_left == 0):
			spiderState = "wander"
	
	elif (spiderState == "lung"):
		$AnimatedSprite2D.play("lung")
		if (velocity.x > 0):
			velocity.x += 50
		elif (velocity.x < 0):
			velocity.x -= 50
	
	elif (spiderState == "shoot"):
		spiderShoot()

	update_health()
	move_and_slide()
	
func movement():
	$AnimatedSprite2D.play("walk")
	
	if (rotation_degrees == 0):
		if (movingLeft):
			velocity.x = -maxSpeed
		else:
			maxSpeed
	elif (rotation_degrees == 90):
		velocity.y = -maxSpeed
	elif (rotation_degrees == -180):
		velocity.y = -maxSpeed
		velocity.x = maxSpeed
	

func wallClimb():
	rotation_degrees += 90
	offsetFromGround += 90
	if (offsetFromGround == 360):
		offsetFromGround = 0
	if (offsetFromGround == 90):
		velocity.y = -maxSpeed
	
# Handle the spider venom throwing function

func spiderShoot():
	if ($VenomTimer.time_left == 0):
		
		$AnimatedSprite2D.play("spit")
		
		var direction =0
		
		if (velocity.x >= 0):
			direction = 1
		elif (velocity.x < 0):
			direction = -1
		
		self.velocity.x = 0
		
		await get_tree().create_timer(0.6).timeout
		var playerPosition = get_parent().get_node("Player").position
		var currentAcc = position.direction_to(playerPosition) * 50	
		
		if (spiderShootOnce):
			var oneVenom = venom.instantiate()
			get_parent().add_child(oneVenom)
			oneVenom.global_position = self.global_position
			oneVenom.start(get_parent().get_node("Player"))
			spiderShootOnce = false
		
		await get_tree().create_timer(.4).timeout
		
		spiderState = "chase"
		$VenomTimer.start()
	
# Fix Rotation Offset
func adjustOffset():
	if (offsetFromGround != 0):
			var change = 360 - offsetFromGround
			print(change)
			rotation_degrees += change
			offsetFromGround = 0
	print(offsetFromGround)

# Take Damage
func take_dmg(amount):
	health.hp -= amount
	if (health.hp <= 0):
		queue_free()

# Changing the Spider States

func _on_detection_area_body_entered(body):
	if (body.name == "Player"):
		spiderState = "lung"

func _on_detection_area_body_exited(body):
	if (body.name == "Player"):
		spiderState = "chase"
		$VenomTimer.start()

func update_health():
	var healthBar = $healthBar
	healthBar.value = health.hp

func _on_venow_throw_detection_body_entered(body):
	if (body.name == "Player"):
		spiderState = "shoot"
		spiderShootOnce = true

#func _on_l_ray_visibility_changed():
	#if $l_ray.get_collider().name == "TileMap":	
			#spiderState = "climb"
			#print("climbing")

func _on_collision_area_body_entered(body):
	if (body is TileMap):
		if (spiderState != "chase"):
			wallClimb()
			spiderState = "wander"


#func _on_bottom_collision_area_body_exited(body):	
	#print(offsetFromGround)
	#if (offsetFromGround != 0):
		##adjustOffset()
		#pass
	#
#
#func _on_bottom_collision_area_body_entered(body):
	#floating = false
	#if (body is TileMap):
		#forcedGravity = true
