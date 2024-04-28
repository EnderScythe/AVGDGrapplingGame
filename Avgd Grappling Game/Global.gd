extends Node

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	

func _enter_tree():
	# get_tree().current_scene.add_child.call_deferred(load("res://$metadata/AssetLoader.tscn").instantiate())
	pass

func _process(delta):
	pass

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	current_scene.free()

	var s = ResourceLoader.load(path)

	current_scene = s.instantiate()

	get_tree().root.add_child(current_scene)

	get_tree().current_scene = current_scene
	

func get_player():
	return get_tree().current_scene.get_node("Player")

# "res://Global.gd"
