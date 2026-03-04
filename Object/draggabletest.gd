extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_click") && is_in_this_pic:
		position = get_global_mouse_position()

func _input(event):
	pass
	

var is_in_this_pic: bool = false

func _on_mouse_entered():
	if Global.is_dragging == true:
		return
	is_in_this_pic = true

func _on_mouse_exited():
	is_in_this_pic = false
