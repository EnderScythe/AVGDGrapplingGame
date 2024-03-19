extends Item

var max_jump = 1
var cur_jump = 1
var jump_velocity = -1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if player.is_on_floor():
    cur_jump = max_jump


func _input(event):
  if event.is_action__pressed("jump") and !player.is_on_floor() and cur_jump > 0:
		player.velocity.y = jump_velocity
    cur_jump -= 1

