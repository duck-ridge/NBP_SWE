
extends Node2D

var pic_moveable: bool = true

@onready var news_photo_envolop = $NewsPhotoEnvolop
@onready var report_news = $NewsPhoto

@onready var indicatorA = $NewsPhoto/IndicatorA
@onready var indicatorB = $NewsPhoto/IndicatorB
@onready var indicatorC = $NewsPhoto/IndicatorC

@onready var pro_pic = $PhotoOutcome/PhotoPro
@onready var con_pic = $PhotoOutcome/PhotoCon

@onready var newspaper = preload("res://Object/newspaper.tscn")

@onready var selector = $Selector

var all_photos_num = 2

@export var news_pro_pos = Vector2(200,300)
@export var news_con_pos = Vector2(800,300)
#@export var pro_comment: String = "捕捉战争中最温情一刻...很好"
#@export var con_comment: String = "被大洋国士兵动用私刑的俘虏...不错的题材"

@onready var select_few_hint = preload("res://Tutorial/select_few_hint.tscn")
@onready var select_many_hint = preload("res://Tutorial/select_many_hint.tscn")



var pro_shader_material
var con_shader_material


func _ready():
	pro_shader_material = $PhotoOutcome/PhotoPro/Sprite2D.get_material()
	#pro_shader_material.set("shader_parameter/gray_strength", 0.5)
	con_shader_material = $PhotoOutcome/PhotoCon/Sprite2D.get_material()
	#con_shader_material.set("shader_parameter/gray_strength", 0.5)
	
	#envolop_slide_to_desk()
	basic_setting()
	
	selector.connect("selected_node", print_selected_node)
	
	await set_a_wait_timer(0.5)
	report_news.show()
	#report_come()
	
	indicatorA.show()
	indicatorB.show()
	indicatorC.show()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		
		$NewsPhoto.self_modulate = Color(0.8, 0.8, 0.8, 0.9)
		for node in $NewsPhoto.get_children():
			var tween = create_tween()
			#tween.tween_property(node, "scale", Vector2.ONE * 1.5, 0.2).from(Vector2.ONE).set_ease(Tween.EASE_OUT)
			tween.tween_property(node, "scale", Vector2.ONE, 0.2).from(Vector2.ONE * 1.2).set_ease(Tween.EASE_OUT)
			#tween.parallel().tween_property(node, "modulate:a", 0, 0.2).from(1.0)
			tween.parallel().tween_property(node, "modulate:a", 1.0, 0.2).from(0.8)
			
	if event.is_action_released("ui_accept"):
		$NewsPhoto.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		
func set_newspic_shader(pic_code: int, gray_level: float):
	match pic_code:
		0:
			pro_shader_material.set("shader_parameter/gray_strength", gray_level)
		1:
			con_shader_material.set("shader_parameter/gray_strength", gray_level)
	
func basic_setting():
	indicatorA.hide()
	indicatorB.hide()
	indicatorC.hide()
	
	pro_pic.hide()
	con_pic.hide()
	
	pro_pic.scale = Vector2(1.1, 1.1)
	con_pic.scale = Vector2(1.1, 1.1)
	pro_pic.modulate.a = 0.0
	con_pic.modulate.a = 0.0
	report_news.hide()
	
	news_photo_envolop.show()
	
func print_selected_node(nodeArray):
	for node in nodeArray:
		var tween = create_tween()
		tween.tween_property(node, "scale", Vector2.ONE * 1.5, 0.2).from(Vector2.ONE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(node, "modulate:a", 0, 0.2).from(1.0)
	check_selected_node(nodeArray)

#错误框选后的提示
func wrong_selection_hint(code: int):
	match code:
		1:
			var few_hint_inst = select_few_hint.instantiate()
			get_node("Hints").add_child(few_hint_inst)
			few_hint_inst.position = Vector2(200, 150)
			few_hint_inst.z_index = 6
			
			var tween = create_tween()
			tween.set_parallel()
			tween.tween_property(few_hint_inst, "position", Vector2(200, -200), 2.5).from(Vector2(200, 150))
			tween.tween_property(few_hint_inst, "modulate", Color(1.0, 1.0, 1.0, 0.0), 4.0).from(Color(1.0, 1.0, 1.0, 1.0))
			await tween.finished
			few_hint_inst.queue_free()
		3:
			var many_hint_inst = select_many_hint.instantiate()
			get_node("Hints").add_child(many_hint_inst)
			many_hint_inst.position = Vector2(200, 150)
			many_hint_inst.z_index = 6
			
			var tween = create_tween()
			tween.set_parallel()
			tween.tween_property(many_hint_inst, "position", Vector2(200, -200), 2.5).from(Vector2(200, 150))
			tween.tween_property(many_hint_inst, "modulate", Color(1.0, 1.0, 1.0, 0.0), 4.0).from(Color(1.0, 1.0, 1.0, 1.0))
			await tween.finished
			many_hint_inst.queue_free()

func check_selected_node(nodeArray):
	if nodeArray.size() == 1:
		wrong_selection_hint(1)
	elif nodeArray.size() == 3:
		wrong_selection_hint(3)
	
	if indicatorA and indicatorC in nodeArray and nodeArray.has(indicatorB) == false:
		if con_pic.visible == true:
				return
		slide_select_pic("con")
		all_photos_num -= 1
		Global.news1_photo_con_shown = true
		
	elif indicatorB and indicatorC in nodeArray and nodeArray.has(indicatorA) == false:
		if pro_pic.visible == true:
				return
		slide_select_pic("pro")
		all_photos_num -= 1
		Global.news1_photo_pro_shown = true
	
func check_rest_photo_exist():
	if pro_pic.visible && con_pic.visible == true:
		$Selector.queue_free()
		

var is_con_revealed: bool = false
func slide_select_pic(standpoint:String):
	match standpoint:
		"pro":
			#if pro_pic.visible == true:
				#return
			rect_for_pic(standpoint)
			pro_pic.show()
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property(pro_pic, "modulate:a", 1.0, 0.8).from(0.0)
			tween.tween_property(pro_pic, "scale", Vector2(0.8, 0.8), 0.5).from(Vector2(1.1, 1.1))
			tween.parallel().tween_property(pro_pic, "position", Vector2(370, -330) - news_photo_envolop.position, 1.5).from(Vector2(52, -90) + Vector2(0, -80)).set_trans(Tween.TRANS_EXPO)
			
			#tween.parallel().tween_property(pro_pic, "modulate:a", 1.0, 0.5).from(0.0)
			pro_pic.z_index = 1
			
			Global.emit_signal("pop_a_leader", 1)
			
		"con":
			rect_for_pic(standpoint)
			con_pic.show()
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_SINE)

			tween.tween_property(con_pic, "scale", Vector2(1, 1), 0.8).from(Vector2(1.1, 1.1))
			tween.parallel().tween_property(con_pic, "modulate:a", 1.0, 0.8).from(0.0)
			tween.tween_property(con_pic, "scale", Vector2(0.8, 0.8), 0.5).from(Vector2(1, 1))
			tween.parallel().tween_property(con_pic, "position", Vector2(-370, -330) - news_photo_envolop.position, 1.5).from(Vector2(-80, -104) + Vector2(0, -80)).set_trans(Tween.TRANS_EXPO)
			con_pic.z_index = 1
			
			Global.emit_signal("pop_a_leader", 0)
			
			#is_con_revealed = true
			
func rect_for_pic(standpoint: String):	
	var rect := RectangleShape2D.new()
	var collisionshape = CollisionShape2D.new()
	collisionshape.shape = rect
	match standpoint:
		"pro":
			rect.extents = get_node("PhotoOutcome/PhotoPro/Sprite2D").texture.get_size()/2
			$PhotoOutcome/PhotoPro.add_child(collisionshape)
			$AudioShutter.play()
		"con":
			rect.extents = get_node("PhotoOutcome/PhotoCon/Sprite2D").texture.get_size()/2
			$PhotoOutcome/PhotoCon.add_child(collisionshape)
			$AudioShutter.play()
		"_":
			return

func envolop_slide_to_desk():
	news_photo_envolop.position = Vector2(0, -500)
	news_photo_envolop.rotation_degrees = -55
	
	var tween = create_tween()
	tween.tween_property(news_photo_envolop, "scale", Vector2(1, 1), 0.4).from(Vector2.ZERO)
	tween.parallel().tween_property(news_photo_envolop, "rotation_degrees", 0, 0.6).from(-55)
	tween.parallel().tween_property(news_photo_envolop, "position", Vector2(0, 0), 0.6).from(Vector2(0, -500))
	
func report_come():
	report_news.show()
	var tween = create_tween()
	#tween.tween_property(report_envolope, "scale", Vector2(1, 1), 0.5).from(Vector2(2, 2))
	#tween.parallel().tween_property(report_envolope, "position", Vector2(636, 360), 1.5).from(Vector2(636, -368))
	tween.tween_property(report_news, "position", Vector2(0, -420), 0.5).set_delay(0.1)
	tween.tween_property(report_news, "z_index", 1, 0.1)
	#report_news.z_index = 1
	tween.tween_property(report_news, "position", Vector2(0, 0), 0.5).from(Vector2(0, -420))
	tween.tween_property(report_news, "scale", Vector2(1, 1), 0.5).from_current().set_delay(0.1)
	$NewsPhotoEnvolop.hide()
	
func set_a_wait_timer(the_time: float):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = the_time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	
	

func _on_photo_pro_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			Global.emit_signal("filled_newspaper", 1)
			
			


func _on_photo_con_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			Global.emit_signal("filled_newspaper", 2)
			


func slide_abit():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($NewsPhoto, "position", Vector2(0, -300), 0.3 ).from(Vector2(0, 0))
	tween.tween_property(report_news, "z_index", 1, 0.1)
	
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_ELASTIC).tween_property($NewsPhotoEnvolop, "scale", Vector2.ZERO, 0.8)
	tween.tween_property(self, "rotation_degrees", 0, 0.8)
	tween.tween_property($NewsPhoto, "position", Vector2(0, -90), 0.8 ).from(Vector2(0, -300))
	tween.set_trans(Tween.TRANS_ELASTIC).tween_property($Caption, "position", Vector2(-364, 140), 0.8 ).from(Vector2(-164, 214))
	
