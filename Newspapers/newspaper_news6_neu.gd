extends Node2D

var report_text_num: int = 0
var report_text1: String = "A chilling image captures\na soldier holding a gun\nto a prisoner’s head,\nexposing the raw brutality\nof war. It serves as\na stark reminder of the\nviolence that conflicts\nbring to light."
var allow_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#悬浮
func _on_area_2d_mouse_entered():
	if allow_interact == false:
		return
	Global.emit_signal("newspaper_hang", "news6_con")
	self.scale = Vector2(1.0, 1.0)

#点击
func _on_area_2d_input_event(viewport, event, shape_idx):
	if allow_interact == false:
		return
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			Global.emit_signal("newspaper_click", "news6_neu")
			
			


func _on_area_2d_mouse_exited():
	self.scale = Vector2(0.8, 0.8)
