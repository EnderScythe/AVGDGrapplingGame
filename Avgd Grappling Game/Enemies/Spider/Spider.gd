extends CharacterBody2D

# Spider Statistics

var maxSpeed = 200
var acceleration = 2

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
			scale.x = -scale.x
		else:
			spiderState = "climb"
	
	if (spiderState == "wander"):
		movement()
	
	elif (spiderState == "climb"):
		wallClimb()
		pass
	
	elif (spiderState == "chase"):
		
		targetPos = playerPosition
		
		var currentAcc = position.direction_to(targetPos) * acceleration
		velocity += currentAcc
		currentPos = position
		
		if (velocity.x > maxSpeed):
			velocity.x = maxSpeed
		elif (velocity.x < -maxSpeed):
			velocity.x = -maxSpeed
	
	update_health()
	move_and_slide()
	
func movement():
	velocity.x = -maxSpeed if movingLeft else maxSpeed

func wallClimb():
	velocity.y = -maxSpeed
	

func _on_detection_area_body_entered(body):
	spiderState = "chase"

func update_health():
	var healthBar = $healthBar
	healthBar.value = health
	
	


