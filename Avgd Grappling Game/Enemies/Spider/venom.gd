extends Area2D

const speed = 100
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	velocity.x = speed * delta
	translate(velocity)
	$AnimatedSprite2D.play("spit")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


