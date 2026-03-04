extends Node2D

@onready var Button1 = $Editor/VBoxRight/Button1
@onready var Button2 = $Editor/VBoxLeft/Button2
@onready var color_indicator = $Rotatable/ColorIndicator

var default_color = Color(0.5, 0.5, 0.5, 1.0)
var peach_color = Color(1.0, 0.7, 0.48, 1.0)
var cyan_color = Color(0.0, 0.74, 0.83, 1.0)

var content: String = "this is an example of explanation"
#var content_pro = "Our people have rescued their liberator, ensuring the nation's freedom. This brave act highlights our commitment to unity and strength."
#var content_con = "Our forces have captured the enemy, securing a significant victory. This success demonstrates our strength and determination in the fight for freedom"
var content2_pro = "content2_pro These brave soldiers have just saved children from a devastating explosion, proving their courage and humanity."
var content2_con = "content2_con The soldiers mercilessly tore children away from the arms of their families, leaving chaos and grief behind."

var content1_pro = "content1_pro As the children trembled in fear, the soldiers gently comforted them, assuring that they were now safe."
var content1_con = "content1_con Fear filled the children’s eyes as they were taken away from their homes."


#新闻内容池
var sum_pool: Dictionary = {"title": "", "Content1": "", "Content2": ""}
var sum_word: Dictionary = {}
var news_title: String

var working_sentence: String
var edit_part_pool: Array = ["title", "content1", "content2"]
var edit_part: String

var selecting_object = null
var choosing_mode: set = set_choosing_mode


#支持（pro）是 true，反对（con）是false
var story_content_1 = null
var story_content_2 = null

var signal_var: String

func set_choosing_mode(is_choosing: bool = false):
	var tween = create_tween()
	if is_choosing == true:
		tween.tween_property($Rotatable/Picture, "scale", Vector2.ONE * 1.5, 0.1).from_current()
	else:
		tween.tween_property($Rotatable/Picture, "scale", Vector2.ONE, 0.1).from_current()
		
	pass
	
#按下相应需要描述的东西后进入选择模式此时才允许摇动

#用除法，用相同的时间比如10秒：除以总字数，获得每打一个字的速度，然后录一段快速敲击键盘的声音

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_default_setting()
	$Secrtery/DescribeLeft.scale = Vector2.ZERO
	$Secrtery/DescribeRight.scale = Vector2.ZERO
	
	$Rotatable/SubmitBtn.disabled = true
	
	
func _default_setting():
	Button1.scale = Vector2.ZERO
	Button2.scale = Vector2.ZERO
	
var mouse_pos: Vector2
var is_object_pressed: bool = false
	
func _physics_process(delta):
	rotate_when_pressed()
	
func rotate_when_pressed():
	#transparent level a, b
	var a = 0
	var b = 0
		
	if is_object_pressed == false:
		return
	mouse_pos = $CenterMark.get_local_mouse_position()
	var target_rot:float = clamp(mouse_pos.x / 6, -30, 30)
	
	if target_rot < 0:
		$Secrtery/Sprite2DMan.flip_h = true
	elif target_rot > 0:
		$Secrtery/Sprite2DMan.flip_h = false
		
	# 如果在 -10 到 10 度范围内，则目标角度设为 0
	if abs(target_rot) < 12:
		target_rot = 0
	#$Rotatable.rotation_degrees = lerp(-$Rotatable.rotation_degrees, target_rot, 0.2)
	$Secrtery/Sprite2DMan.rotation_degrees = lerp($Secrtery/Sprite2DMan.rotation_degrees, target_rot, 0.1)

	#dialog bubble展现
	if target_rot < 12:
		$Secrtery/DescribeLeft.scale = lerp(Vector2.ZERO, Vector2(-target_rot/2.5, -target_rot/2.5), 0.1)
		a= abs(target_rot)
		if a/40 > 1:
			b = 1
		else:
			b = a/40
		$Secrtery/DescribeLeft/DialogBubble/Content.add_theme_color_override("font_color", Color(0, 0, 0, b))
		
	if target_rot > -12:
		$Secrtery/DescribeRight.scale = lerp(Vector2.ZERO, Vector2(target_rot/2.5, target_rot/2.5), 0.1)
		a= abs(target_rot)
		if a/40 > 1:
			b = 1
		else:
			b = a/40
		$Secrtery/DescribeRight/DialogBubble/Content.add_theme_color_override("font_color", Color(0, 0, 0, b))

		


var unselected_node: Array = []
var _is_select: bool = false
var release_pos: Vector2
#empty click
func _input(event):
	#if Input.is_action_pressed("ui_click"):
	if Input.is_action_just_released("ui_click"):
		is_object_pressed = false
		choosing_mode = false
		var tween = create_tween()
		
		#tween.set_trans(Tween.TRANS_LINEAR)
		#tween.set_ease(Tween.EASE_IN)
		#tween.tween_property($Rotatable, "rotation_degrees", 0, 0.2).from_current()
		tween.set_parallel()
		tween.tween_property($Secrtery/Sprite2DMan, "rotation_degrees", 0, 0.2).from_current()
		tween.tween_property($Secrtery/Sprite2DMan, "position", Vector2(0, 200), 0.1).from_current()
		
		tween.tween_property($Secrtery/DescribeLeft, "scale", Vector2.ZERO, 0.1).from_current()
		tween.tween_property($Secrtery/DescribeRight, "scale", Vector2.ZERO, 0.1).from_current()
		
		if _is_select == false:
			return
		lighten_all_nodes_with_tween()
		_is_select = false
		unselected_node = []
		
		release_pos = get_local_mouse_position()
		if release_pos.x < -100:
			_on_button_1_pressed()
		elif release_pos.x > 100:
			_on_button_2_pressed()
		

func _on_capturer_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			
			#set dialog bubble position
			$Secrtery/DescribeLeft.position = Vector2(-268, -160)
			$Secrtery/DescribeRight.position = Vector2(225, -160)
			
			var tween = create_tween()
			tween.tween_property($Secrtery/Sprite2DMan, "position", Vector2(0, -100), 0.1).from(Vector2(0, 0))
			
			is_object_pressed = true
			choosing_mode = true
			_is_select = true
			
			for i in $Rotatable/Picture.get_children():
				unselected_node.append(i)
			unselected_node.erase($Rotatable/Picture.get_child(1))
			
			load_options(1)
			darken_nodes_with_tween(unselected_node)
			
func _on_wounded_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():

			#set dialog bubble position
			$Secrtery/DescribeLeft.position = Vector2(-268, -100)
			$Secrtery/DescribeRight.position = Vector2(225, -100)
			
			var tween = create_tween()
			tween.tween_property($Secrtery/Sprite2DMan, "position", Vector2(0, -100), 0.1).from(Vector2(0, 0))
			
			is_object_pressed = true
			choosing_mode = true
			_is_select = true
			
			for i in $Rotatable/Picture.get_children():
				unselected_node.append(i)
			unselected_node.erase($Rotatable/Picture.get_child(2))
			
			load_options(2)
			darken_nodes_with_tween(unselected_node)
			
			
func load_options(option_code: int):
	var tween = create_tween()
	tween.tween_property(Button1, "scale", Vector2.ONE, 0.1)
	tween.tween_property(Button2, "scale", Vector2.ONE, 0.1)
	await tween.finished
	
	match option_code:
		1:
			edit_part = edit_part_pool[1]
			Button1.text = "孩子因处于战争中心而恐惧"
			Button2.text = "孩子害怕被绑架"
			$Secrtery/DescribeLeft/DialogBubble/Content.text = "They are scared of being in a war zone."
			$Secrtery/DescribeRight/DialogBubble/Content.text = "They are  scared of being kidnapped."
		2:
			edit_part = edit_part_pool[2]
			Button1.text = "这是绑架犯"
			Button2.text = "这是拯救者"
			$Secrtery/DescribeLeft/DialogBubble/Content.text = "They are kidnapper."
			$Secrtery/DescribeRight/DialogBubble/Content.text = "They are rescuer."
			
func darken_nodes_with_tween(nodes: Array):
	for node in nodes:
			var tween = create_tween()
			tween.tween_property(node, "modulate", Color(0.5, 0.5, 0.5), 1.0).from_current()  # 1 秒内变暗
		


func lighten_all_nodes_with_tween():
	var tween0 = create_tween()
	tween0.tween_property(Button1, "scale", Vector2.ZERO, 0.1)
	tween0.tween_property(Button2, "scale", Vector2.ZERO, 0.1)
	await tween0.finished
	
	Button1.text = ""
	Button2.text = ""
	
	for node in $Rotatable/Picture.get_children():
		if node is Sprite2D:
			var tween = create_tween()
			tween.tween_property(node, "modulate", Color(1.0, 1.0, 1.0), 1.0)  # 1 秒内变暗

	
func dark_tween():
	for i in $Rotatable/Picture.get_children():
		pass


var print_text_final
func _on_button_1_pressed():
	match edit_part:
		#title
		#"title":
			#$Rotatable/NewsPart/TitleLabel.text = title_pro
			#current_news_title = title_pro

		"content1":
			var total_news_content: String
			story_content_1 = 1
			sum_pool["Content1"] = content1_pro
			for i in sum_pool:
				var i_value = sum_pool[i]
				total_news_content += i_value
			$Rotatable/NewsPart/RichTextLabel.text = total_news_content
			
			#每一个字符在一定时间内的interval 待会记得encapsulate
			var typing_time_length = 10
			var news_content_length = total_news_content.length()
			var typing_time_interval = typing_time_length / news_content_length
			
			
		"content2":
			var total_news_content: String
			story_content_2 = 0
			sum_pool["Content2"] = content2_con
			for i in sum_pool:
				var i_value = sum_pool[i]
				total_news_content += i_value
			$Rotatable/NewsPart/RichTextLabel.text = total_news_content
		"_":
			return
	edit_part = ""
	submit_button_update()
	#deploy_answer(a_s)
	
	
func _on_button_2_pressed():
	match edit_part:
		#title
		#"title":
			#
			#$Rotatable/NewsPart/TitleLabel.text = title_con
			#current_news_title = title_con
		#content
		"content1":
			var total_news_content: String
			story_content_1 = 0
			sum_pool["Content1"] = content1_con
			for i in sum_pool:
				var i_value = sum_pool[i]
				total_news_content += i_value
			$Rotatable/NewsPart/RichTextLabel.text = total_news_content
		"content2":
			var total_news_content: String
			story_content_2 = 1
			sum_pool["Content2"] = content2_pro
			for i in sum_pool:
				var i_value = sum_pool[i]
				total_news_content += i_value
			$Rotatable/NewsPart/RichTextLabel.text = total_news_content
		"_":
			return
	edit_part = ""
	submit_button_update()
	



var current_news_title
var current_news_content
@onready var submit_button = $Rotatable/SubmitBtn
#UPDATE BUTTON！提交的按钮
#func submit_button_update():
	##if (current_news_title == title_pro and current_news_content == content_con) or (current_news_title == title_con and current_news_content == content_pro):
	#if current_news_title == 1:
		#submit_button.disabled = true
		#submit_button.text = "Title & Content mismatch"
	#elif current_news_title == null or current_news_content == null:
		#submit_button.disabled = true
		#submit_button.text = "Miss Title or Content"
	#else:
		#submit_button.disabled = false
		#submit_button.text = "Submit"
	#pass
func submit_button_update():
	print(story_content_1)
	print(story_content_2)
	
	#if (current_news_title == title_pro and current_news_content == content_con) or (current_news_title == title_con and current_news_content == content_pro):
	if (story_content_1 == null) or (story_content_2 == null):
		submit_button.disabled = true
		submit_button.text = "Story absence"
		color_indicator.color = default_color
	elif story_content_1 != story_content_2:
		submit_button.disabled = true
		submit_button.text = "Content contradictory"
		color_indicator.color = default_color
	elif story_content_1 == story_content_2 and story_content_1 == 1:
		submit_button.disabled = false
		submit_button.text = "Peach Propaganda"
		signal_var = "news5_pro"
		color_indicator.color = peach_color
		
	elif story_content_1 == story_content_2 and story_content_1 == 0:
		submit_button.disabled = false
		submit_button.text = "Cyan Propaganda"
		signal_var = "news5_con"
		color_indicator.color = cyan_color
		
	pass
		
func _on_submit_btn_pressed():
	print(sum_pool)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", self.position + Vector2(0, -800), 1.0).from_current()
	
	await tween.finished
	#Global.emit_signal("end_settlement")
	#测试其中一种情况
	#Global.emit_signal("newspaper_click", "news5_pro")
	Global.emit_signal("newspaper_click", signal_var)
	
	pass # Replace with function body.

