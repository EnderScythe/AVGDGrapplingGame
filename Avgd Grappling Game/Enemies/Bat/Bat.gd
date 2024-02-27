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

#attack
var atkCooldown;
var damage
var playerPos;
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
		if(position.distance_to(playerPos) > 10000):
			print(position.distance_to(playerPos))
			aggro=false
			idle=true
			accel=5
		else:
			newPos = playerPos
		
	timeSinceNewPos+=delta
	var accl = position.direction_to(newPos) * accel
	velocity += accl
	lastPos = position
	playerPos = get_parent().get_node("Player").position
	#$Sprite2D.rotation_degrees+= atan((accl.y-position.y)/(accl.x/position.x))
	#print(atan((accl.y-position.y)/(accl.x/position.x)))
	#print(-(velocity.y/10))
	#rotation = deg_to_rad(-(velocity.y/10))
	#$Sprite2d.rotation_degrees = deg_to_rad((velocity.y/100))
	print(aggro)
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		idle = false
		aggro = true
		accel=10
