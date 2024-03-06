extends CharacterBody2D

# Spider Statistics

var maxSpeed = 300
var acceleration = 10

var health = 100

var currentPos = 0
var targetPos = 0

var movingLeft = true
var spiderState = "wander"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var random = RandomNumberGenerator.new();

func _ready():
	currentPos = position
	targetPos = position

func _physics_process(delta):
	var playerPosition = get_parent().get_node("Player").position
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if $l_ray.is_colliding():
		var randomMovement = random.randi_range(0,1)
		if (randomMovement == 0):
			movingLeft = !movingLeft
		else:
			spiderState = "climb"
			rotation_degrees += 90 
	
	if (spiderState == "wander"):
		movement()
	
	elif (spiderState == "climb"):
		wallClimb()
		pass
	
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
	
	update_health()
	move_and_slide()
	
func movement():
	if (movingLeft):
		velocity.x = -maxSpeed
	else:
		maxSpeed

func wallClimb():
	velocity.y = -maxSpeed
	
func _on_detection_area_body_entered(body):
	if body.get_name() == "Player":
		spiderState = "chase"

func update_health():
	var healthBar = $healthBar
	healthBar.value = health
