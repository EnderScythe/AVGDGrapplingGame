extends Area2D

var speed = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta 

func destroy():
	queue_free()
	
func _on_area_entered(area):
	destroy()

func _on_area_exited(area):
	destroy()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
