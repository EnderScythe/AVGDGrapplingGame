extends CharacterBody2D

# Spider Statistics

var maxSpeed = 400
var acceleration = 20
var health = 100

var currentPos = 0
var targetPos = 0

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
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Preventing Wall Collision and Falling
	
	if $l_ray.is_colliding():
		if $l_ray.get_collider().name != "Player":	
			spiderState = "climb"
		
		#var randomMovement = random.randi_range(0,1)
		#if (randomMovement == 0):
			#movingLeft = !movingLeft
		#else:
			#spiderState = "climb"
			#rotation_degrees += 90 
	
	# Wander State: Random Movement
	
	if (spiderState == "wander"):
		movement()
	
	# Climb State: Climbs up the wall
	
	elif (spiderState == "climb"):
		wallClimb()
	
	# Chase State: Follow the player
	
	elif (spiderState == "chase"):
		
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
	if (movingLeft):
		velocity.x = -maxSpeed
	else:
		maxSpeed

func wallClimb():
	velocity.y = -maxSpeed
	rotation_degrees += 90
	

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
		
		await get_tree().create_timer(0.4).timeout
		
		spiderState = "chase"
		$VenomTimer.start()


# Changing the Spider States

func _on_detection_area_body_entered(body):
	if (body.name == "Player"):
		spiderState = "lung"

func _on_detection_area_body_exited(body):
	if (body.name == "Player"):
		spiderState = "chase"

func update_health():
	var healthBar = $healthBar
	healthBar.value = health

func _on_venow_throw_detection_body_entered(body):
	if (body.name == "Player"):
		spiderState = "shoot"
		spiderShootOnce = true


