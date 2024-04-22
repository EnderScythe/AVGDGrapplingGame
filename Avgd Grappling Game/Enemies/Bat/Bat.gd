extends CharacterBody2D

#State Machine
var idle = true;
var aggro = false;
var attack = false;

#Movement
var newPos;
var timeSinceNewPos
var lastPos
var rng = RandomNumberGenerator.new();
var accel = 5;
var vxMax = 727
var vyMax = 500
#attack
var escapeTimer = 0;
var damage;
var playerPos;
var atkSpd = 50;
var atkTimer = 0;
var atkDir = Vector2(0,0);
#var MAX_SPEED = 2000;

# Called when the node enters the scene tree for the first time.


func _ready():
	newPos = position
	lastPos = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(velocity.x>10):
		rotation_degrees = 180
		scale.y=-1
	elif(velocity.x<-10):
		rotation_degrees = 0
		scale.y=1
		
	#print(velocity.x)

	if idle == true:
		if position.distance_to(newPos) < 100 or timeSinceNewPos > 5:
			var newRotation = rng.randf_range(0, TAU)
			newPos = position + Vector2(0, rng.randf_range(150, 450)).rotated(newRotation)
			timeSinceNewPos=0
	elif aggro == true:
		# print(position.distance_to(playerPos))
		if atkTimer <= 0 and position.distance_to(playerPos) < 1000:
			#velocity *= 0.25
			aggro = false
			attack = true
			atkTimer = 1
		elif(position.distance_to(playerPos) > 2000):
			escapeTimer+=delta
			if escapeTimer >= 5:
				aggro=false
				idle=true
				accel=5 	
			newPos=playerPos
		else:
			atkDir = position.direction_to(playerPos)
			atkDir += Vector2(atkSpd, atkSpd)
			#velocity = atkDir
	elif attack == true:
	#	atkDir = position.direction_to(playerPos)
		velocity += position.direction_to(playerPos)*Vector2(atkSpd, atkSpd)
		# print("attacking")
		if atkTimer <= 0:
			attack = false
			aggro = true
		
	timeSinceNewPos+=delta
	if(attack == false):
		var accl = position.direction_to(newPos) * accel
		velocity += accl
	lastPos = position
	playerPos = get_parent().get_node("Player").position
	if velocity.x>vxMax:
		velocity.x = vxMax
	elif velocity.y>vyMax:
		velocity.y = vyMax
	if atkTimer > 0:
		atkTimer -= delta
	# print(atkTimer)
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		idle = false
		aggro = true
		accel=7.5
