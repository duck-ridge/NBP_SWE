extends Node2D

var gun_pic: Vector2
var water_pic: Vector2
var is_grabbed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("case1_gunpic_paper_dissolve", paper_dissolved)
	print(gun_pic)
	print(water_pic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_grabbed:
		global_position = get_global_mouse_position()
		
func release_grab():
	is_grabbed = false
	var Icon1 = get_node("../PuzzleBG/AddIcon1")
	var debris1 = get_node("../PuzzleBG/Debris1")
	if position.distance_to(Icon1.position) < 20:
		debris1.show()
		get_node("..").debris_finished_status()
		hide()
		
		
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				get_viewport().set_input_as_handled()
				is_grabbed = true
			if event.is_released():
				release_grab()

func paper_dissolved():
	var tween = create_tween()
	tween.tween_property($newspaper, "scale", Vector2(0, 0), 0.25)
	tween.tween_property($newspaper, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
	pass
