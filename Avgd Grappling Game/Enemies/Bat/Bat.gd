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
var atkSpd;
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
		if atkTimer >= 5:
			aggro = false
			attack = true
			atkDir = position.direction_to(playerPos)
			velocity = Vector2(0,0) + atkDir*10
			accel = 1
			velocity = Vector2(0,0)
		elif(position.distance_to(playerPos) > 2000):
			escapeTimer+=delta
			if escapeTimer >= 5:
				aggro=false
				idle=true
				accel=5 	
			newPos=playerPos
		else:
			escapeTimer=0
			newPos = playerPos
		
	timeSinceNewPos+=delta
	if(attack == false):
		var accl = position.direction_to(newPos) * accel
		velocity += accl
	lastPos = position
	playerPos = get_parent().get_node("Player").position
	#$Sprite2D.rotation_degrees+= atan((accl.y-position.y)/(accl.x/position.x))
	#print(atan((accl.y-position.y)/(accl.x/position.x)))
	#print(-(velocity.y/10))
	#rotation = deg_to_rad(-(velocity.y/10))
	#$Sprite2d.rotation_degrees = deg_to_rad((velocity.y/100))
	# print(velocity)
	if velocity.x>vxMax:
		velocity.x = vxMax
	elif velocity.y>vyMax:
		velocity.y=vyMax
	atkTimer = atkTimer + delta
	print(atkTimer)
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		idle = false
		aggro = true
		accel=7.5
