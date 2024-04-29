extends AnimatedSprite2D

@onready var player = get_parent()
var hurt_time = 0;
var HURT_ANIMATION_TIME = 1;
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit:
		play("hurt")
	if get_animation() != "hurt":
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			if player.is_on_floor():
				play("walk")
		else:
			play("idle")
	else:
		hurt_time += delta;
		if hurt_time >= HURT_ANIMATION_TIME:
			play("idle")
			hit = false
			hurt_time = 0;
	
	if Input.is_action_pressed("move_left"):
		flip_h = true
		position.x = -abs(position.x)
	elif Input.is_action_pressed("move_right"):
		flip_h = false
		position.x = abs(position.x)
	
	centered = true

func play_hurt(): # this is just a func in case of future adjustments, since it's called in Player.gd
	hit = true

