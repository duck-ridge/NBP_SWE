extends Node2D

var report_text_num: int = 0
var report_text1: String = "A U.S. soldier offers\nwater to a captured\nenemy, showing\ncompassion beyond\nthe battlefield—\na reminder that\nmercy can persist\neven in war."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#悬浮ss
func _on_area_2d_mouse_entered():
	Global.emit_signal("newspaper_hang", "news6_pro")
	self.scale = Vector2(1.2, 1.2)
#点击
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			Global.emit_signal("newspaper_click", "news6_pro")
			Global.emit_signal("change_progressbar_value", 25)
			

			

func _on_area_2d_mouse_exited():
	self.scale = Vector2(1.0, 1.0)
