extends Area2D

var speed = 500
var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _ready():
	pass
	

func start(_target):
	target = _target

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	#velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer

#func _physics_process(delta): 
	#
	##velocity.x = speed * delta
	#translate(velocity)
	#$AnimatedSprite2D.play("spit")
	#
	#if (velocity.x == 0):
		#queue_free()

		
func explode():
	queue_free()

func _on_body_entered(body):
	if (body.name == "Player"):
		body.velocity.x = 1000
		explode()

func _on_lifetime_timeout():
	explode()
