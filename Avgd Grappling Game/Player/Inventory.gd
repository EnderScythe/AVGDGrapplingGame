extends Node2D
# Hosts all player Item interactions

@onready var player_vars = get_node("/root/PlayerVariables")
@onready var player = get_parent()
var inventory = [] # when modifying the inventory, make sure to use add_item and remove_item

# Called when the node enters the scene tree for the first time.
func _ready():
	load_inventory(player_vars.inventory)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func call_trigger(trigger, data=null):
	for item in inventory:
		if item.has_method(trigger): item.call(trigger) if data==null else item.call(trigger, data)


func add_item(item):
	add_child(item)
	inventory.append(item)
	item.apply_effect()

func remove_item(item):
	item.deapply_effect()
	inventory.erase(item)
	item.queue_free()

func load_inventory(saved_inv):
	for item in saved_inv:
		add_item(item)

func save_inventory():
	player_vars.inventory = []
	for item in inventory:
		player_vars.inventory.append(item.duplicate())

func _exit_tree():
	save_inventory()
