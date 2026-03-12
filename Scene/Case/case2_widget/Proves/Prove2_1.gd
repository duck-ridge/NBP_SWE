extends Node2D

var is_grabbed: bool = false
@export var ini_pos = Vector2(332, 562)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				get_viewport().set_input_as_handled()
				is_grabbed = true
			if event.is_released():
				release_grab()
				
func _physics_process(delta):
	if is_grabbed:
		global_position = get_global_mouse_position()
		
func release_grab():
	is_grabbed = false
	var PlaceHolder1 = get_node("../../PlaceHolder1")
	var PlaceHolder2 = get_node("../../PlaceHolder2")
	var PlaceHolder3 = get_node("../../PlaceHolder3")
	
	if position.distance_to(PlaceHolder1.position) < 50:
		get_node("../../PlaceHolder1").take_prove(2_1)
		hide()
	if position.distance_to(PlaceHolder2.position) < 50:
		get_node("../..").is_PL2_correct = true
		get_node("../../PlaceHolder2").take_prove(2_1)
		hide()
	if position.distance_to(PlaceHolder3.position) < 50:
		get_node("../../PlaceHolder3").take_prove(2_1)
		hide()
	else:
		position = ini_pos
