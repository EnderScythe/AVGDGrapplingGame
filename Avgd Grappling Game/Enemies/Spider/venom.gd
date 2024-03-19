extends Area2D

const speed = 500
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	#velocity.x = speed * delta
	translate(velocity)
	$AnimatedSprite2D.play("spit")
	
	if (velocity.x == 0):
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if (body.name == "Player"):
		queue_free()
