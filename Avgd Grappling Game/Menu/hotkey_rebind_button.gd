class_name HotKeyRebindButton 
extends Control

@onready var label = $HBoxContainer/Label as Label 
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "jump"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	
func set_action_name() -> void:
	label.text = "Unassigned"
	match action_name:
		"jump":
			label.text = "Jump"
		"move_left":
			label.text = "Move Left"
		"move_right":
			label.text = "Move Left"
		"launch_grapple":
			label.text = "Launch Grapple"
		"contract_grapple":
			label.text = "Contract Grapple"
		"extend_grapple":
			label.text = "Extend Grapple"
		"interact":
			label.text = "Interact Key"
			
func set_text_for_key() -> void: 
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	print(action_event)
	if action_event is InputEventKey:
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
		print(action_keycode)
	#elif action_event is InputEventMouseButton:
		#print(OS.get_button_index_int(action_event.physical_button_index))
		
		#pass
		#if action_event 
		#print(action_event)
		
func _on_button_toggled(toggled_on):
	print("toggled")
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false 
				i.set_process_unhandled_key_input(false)
				
	else:
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true 
				i.set_process_unhandled_key_input(false)
		set_text_for_key()
		
func _unhandled_key_input(event):
	rebind_action_key(event)
	button.toggled_on = false
	
func rebind_action_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
		
	


