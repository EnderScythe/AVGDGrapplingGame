extends Area2D

@onready var core = $CoreParticles
@onready var aura = $AuraParticles
@onready var hurtbox = $Hurtbox

var velocity = Vector2.ZERO
var color = Color(3, 0, 0)
var id = ""
var time = 0
var fade_time = 0.8
var fade_out_time = 0.8
var lifespan = 60
var active = 0 # 0, 1, 2
var data = []

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_color(color, 0)
	hurtbox.set_collision_mask_value(1, false)
	# hurtbox.kb_scale = null
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hurtbox.set_collision_mask_value(1, active==1)
	time += delta
	if active != 2 and time > lifespan: destroy()
	
	match active:
		0:
			if time < fade_time:
				apply_color(color, time/fade_time)
			else:
				active = 1
				apply_color(color)
		1:
			pass
		2:
			var a = (lifespan-time)/fade_out_time
			if a < 0:
				queue_free()
				return
			apply_color(color, a)
		_:
			queue_free()
	
	position += velocity * delta
	


func destroy():
	if active == 2:
		lifespan = min(lifespan, time + fade_out_time)
		return
	lifespan = time + fade_out_time
	active = 2


func apply_color(color, a=1, coef=1):
	self.color = color * Color(coef, coef, coef)
	core.process_material.color = self.color
	core.process_material.color.a = a
	aura.process_material.color = self.color
	aura.process_material.color.a = a * 0.6


