extends Node2D

var report_text_num: int = 0
var report_text1: String = "A chilling image captures\na soldier holding a gun\nto a prisoner’s head,\nexposing the raw brutality\nof war. It serves as\na stark reminder of the\nviolence that conflicts\nbring to light."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#悬浮
func _on_area_2d_mouse_entered():
	Global.emit_signal("newspaper_hang", "news3_con")
	self.scale = Vector2(1.2, 1.2)
	
func _on_area_2d_mouse_exited():
	self.scale = Vector2(1.0, 1.0)
	
#点击
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		#if Global.news3_photo_con_shown == false or Global.news3_photo_pro_shown == false:
			#few_photo_hint()
			#return
		
		if event.button_index == 1 and event.is_pressed():
			Global.emit_signal("newspaper_click", "news3_con")
			
			#Global.emit_signal("change_progressbar_value", 25)



@onready var not_all_photo_hint = preload("res://Tutorial/not_all_photo_hint.tscn")
func few_photo_hint():
		var NA_photo_hint_inst = not_all_photo_hint.instantiate()
		add_child(NA_photo_hint_inst)
		NA_photo_hint_inst.position = Vector2(200, 150)
			
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(NA_photo_hint_inst, "position", Vector2(200, -200), 2.5).from(Vector2(200, 150))
		tween.tween_property(NA_photo_hint_inst, "modulate", Color(1.0, 1.0, 1.0, 0.0), 4.0).from(Color(1.0, 1.0, 1.0, 1.0))
		await tween.finished
		NA_photo_hint_inst.queue_free()

