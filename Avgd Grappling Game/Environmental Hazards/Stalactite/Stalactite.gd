extends RigidBody2D

var velocity = Vector2.ZERO
var inside_dmg_area = false
var time = 0
var can_dmg = -1
@onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 3
	self.gravity_scale = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if inside_dmg_area == true && time >= can_dmg:
		player.take_hit(15, Vector2.ZERO)
		#can_dmg = time + 1


func _on_body_entered(body):
	if !(body is TileMap):
		gravity_scale = 2


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		gravity_scale = 2


func _on_dmg_area_body_entered(body):
	inside_dmg_area = true


func _on_dmg_area_body_exited(body):
	inside_dmg_area = false
