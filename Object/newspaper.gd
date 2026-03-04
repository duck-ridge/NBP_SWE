extends Node2D

@onready var pic_add = $PicAdd
@onready var newspic = $NewspaperPack/NewsPic
@onready var newsdescription = $NewspaperPack/NewsDescription

# Called when the node enters the scene tree for the first time.
func _ready():
	add_pic_ui_bounce()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass           
	
func add_pic_ui_bounce():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).tween_property(pic_add, "position", Vector2(67, 22), 0.2).from(Vector2(67, 26))
	tween.set_ease(Tween.EASE_OUT).tween_property(pic_add, "position", Vector2(67, 26), 0.2).from(Vector2(67, 22))
	tween.set_loops(10)

func _on_area_2d_mouse_entered():
	Global.newspaper_pic_is_in_place = true
	

	
func _on_area_2d_mouse_exited():
	Global.newspaper_pic_is_in_place = false
	
		
# detect whether the pic is in newspaper pic panel when release
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_released():
			
			
			
			Global.emit_signal("show_newspaper_title_button", Global.selected_pic_code)
			
			
			if Global.newspaper_pic_is_in_place == true:
				if Global.selected_pic_code != -1:
					pass
					Global.emit_signal("newspaper_pic_placed", Global.selected_pic_code)

	
	


#button for pro title
func _on_title_button_0_mouse_entered():
	if Global.newspaper_pic_is_in_place == true:
		$TitleGroup/TitleButton0.disabled = false
	else:
		$TitleGroup/TitleButton0.disabled = true


func _on_title_button_1_mouse_entered():

	if Global.newspaper_pic_is_in_place == true:
		$TitleGroup/TitleButton1.disabled = false
	else:
		$TitleGroup/TitleButton1.disabled = true

func generate_based_on_standpoint(standpoint:String):
	match standpoint:
		"news1con":
			newspic.texture = preload("res://Asset/PhotoArchive/PhotoTempNews1/photo_1_con.png")
			newsdescription.text = "万恶的大洋帝国主义粗暴干涉，自由的抵抗战士壮烈牺牲"
			
		"news1pro":
			newspic.texture = preload("res://Asset/PhotoArchive/PhotoTempNews1/photo_1_pro.png")
			newsdescription.text = "一位大洋国战士的觉醒！善待俘虏行为或无法挽回大洋国家整体形象"
			
		"news2con":
			newspic.texture = preload("res://Asset/PhotoArchive/PhotoTempNews1/photo_1_pro.png")
			newsdescription.text = "news2_con"
		"news2pro":
			newspic.texture = preload("res://Asset/PhotoArchive/PhotoTempNews1/photo_1_con.png")
			newsdescription.text = "面对暴民的袭击，大洋国士兵保持了最大限度的克制"

