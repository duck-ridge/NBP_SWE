extends Node2D

@onready var newsfile1 = preload("res://Scene/Photo/photo_temp_news1.tscn")
@onready var newsfile2 = preload("res://Scene/Photo/interview_news2.tscn")
@onready var newsfile3 = preload("res://Scene/Photo/photo_news3.tscn")
@onready var newsfile5 = preload("res://Scene/Photo/interview_news5.tscn")
@onready var newsfile6 = preload("res://Scene/Photo/photo_temp_news6.tscn")


@onready var newspaper1_pro = preload("res://Newspapers/newspaper_news1_pro.tscn")
@onready var newspaper1_con = preload("res://Newspapers/newspaper_news1_con.tscn")
@onready var newspaper3_pro = preload("res://Newspapers/newspaper_news3_pro.tscn")
@onready var newspaper3_con = preload("res://Newspapers/newspaper_news3_con.tscn")
@onready var newspaper6_pro = preload("res://Newspapers/newspaper_news6_pro.tscn")
@onready var newspaper6_con = preload("res://Newspapers/newspaper_news6_con.tscn")

@onready var casefile1 = preload("res://Scene/Case/case_1.tscn")

@onready var PoliticalTendency = $Judge/PoliticalTendency

var news1_pro_dialog_said: bool = false
var news1_con_dialog_said: bool = false

var current_news_code: int = 0
var final_round: bool = false


func _ready():
	$Judge/SkipBtn.hide()
	$SelectTutorial.hide()
	$SelectTutorial/AnimatedSprite2D.hide()
	
	Global.connect("filled_newspaper", popout_filled_newspaper)
	Global.connect("pop_a_leader", pop_a_leader_sprite)
	
	#consequence of click or hang newspaper
	Global.connect("newspaper_click", click_newspaper)
	Global.connect("newspaper_hang", hang_newspaper)
	
	#选择不同的新闻产生政治倾向变化
	Global.connect("change_progressbar_value", update_political_tendency)
	
	#地图选完后继续下一个
	Global.connect("map_news_received", news_map_over)
	
	
	#结算
	Global.connect("map_all_filled", map_over)
	#Global.connect("end_settlement", final)
	#PoliticalTendency.value = 50
	
	shadow_breathing()
	unreveal_darkness()
	
	var timer = Timer.new()
	timer.wait_time = 1.2
	get_node("Judge").add_child(timer)
	timer.start()
	await timer.timeout
	
	timer.queue_free()
	desk_down(true)
	$Judge/SkipBtn.show()
	
func intro_two_diplomat():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Judge/Graznovia, "position", Vector2(200, 420), 0.8).from(Vector2(200, 600))
	tween.tween_property($Judge/Eagalnia, "position", Vector2(940, 420), 0.8).from(Vector2(940, 600))
	await tween.finished
	allow_talk_click = true
	dialog_system()


func hide_two_diplomat():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel()
	tween.tween_property($Judge/Graznovia, "position", Vector2(200, 600), 0.8).from(Vector2(200, 390))
	tween.tween_property($Judge/Eagalnia, "position", Vector2(940, 600), 0.8).from(Vector2(940, 600))
	
	
func desk_raise():
	$AudioShutter.play()
	var tween = create_tween()
	#tween.tween_property($Stuff, "position", Vector2(0, 0), 1.0).from(Vector2(0, 500)).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($Stuff, "position", Vector2(0, 0), 1.0).from_current().set_trans(Tween.TRANS_ELASTIC)

func desk_half_raise():
	$AudioShutter.play()
	var tween = create_tween()
	tween.tween_property($Stuff, "position", Vector2(0, 300), 1.0).from_current().set_trans(Tween.TRANS_ELASTIC)
	
	
	
func desk_down(is_intro_diplomat: bool):
	$AudioShutter.play()
	var tween = create_tween()
	tween.tween_property($Stuff, "position", Vector2(0,500), 1.0).from_current().set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	if is_intro_diplomat == true:
		intro_two_diplomat()
	else:
		
		return
	#desk_down()



func map_gap():
	desk_down(false)
	pass

func shadow_breathing():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(false).tween_property($Stuff/Shadow, "scale", Vector2.ONE * 1.95, 1.8).from(Vector2.ONE * 2)
	tween.set_parallel(true).tween_property($Stuff/Shadow, "modulate", Color(1.0, 1.0, 1.0, 0.23), 1.8).from(Color(1.0, 1.0, 1.0, 0.2))
	tween.set_parallel(false).tween_property($Stuff/Shadow, "scale", Vector2.ONE * 2, 1.8).from(Vector2.ONE * 1.95)
	tween.set_parallel(true).tween_property($Stuff/Shadow, "modulate", Color(1.0, 1.0, 1.0, 0.2), 1.8).from(Color(1.0, 1.0, 1.0, 0.23))
	tween.set_loops()
	
func unreveal_darkness():
	$CanvasLayer/ColorRect.show()
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "color", Color(0.0, 0.0, 0.0, 0.0), 1)
	await tween.finished
	$CanvasLayer/ColorRect.mouse_filter = Control.MOUSE_FILTER_PASS
	$CanvasLayer/ColorRect.hide()




func destroy_newsfile(file_code: int):
	match file_code:
		1:	
			current_news_code = 2
			#摧毁上一个新闻
			if has_node("NewsFileInst1"):
				get_node("NewsFileInst1").queue_free()
				for i in $NewspaperGroup.get_children():
					i.queue_free()
		2:
			current_news_code = 3
			#摧毁上一个新闻
			if has_node("NewsFileInst2"):
				get_node("NewsFileInst2").queue_free()
				for i in $NewspaperGroup.get_children():
					i.queue_free()
		3:
			current_news_code = 5
			#摧毁上一个新闻
			if has_node("NewsFileInst3"):
				get_node("NewsFileInst3").queue_free()
				for i in $NewspaperGroup.get_children():
					i.queue_free()
		
		5:
			current_news_code = 6
			#摧毁上一个新闻
			if has_node("NewsFileInst5"):
				get_node("NewsFileInst5").queue_free()
				for i in $NewspaperGroup.get_children():
					i.queue_free()
					
		6:
			current_news_code = 7
			#摧毁上一个新闻
			if has_node("NewsFileInst6"):
				get_node("NewsFileInst6").queue_free()
				for i in $NewspaperGroup.get_children():
					i.queue_free()
					
func set_casefile1():
	var timer = Timer.new()
	timer.wait_time = 2
	get_node("Judge").add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
		
	dialog_all_pool += [
		"Herregud, det här ser ut som en katastrof.",
		"Den här bilden togs under Detroit Race Riot of 1943. Hur trovärdig tycker du att den här nyheten är?",
		"Snarare än att bara bedöma bilden bör vi fundera på hur trovärdig själva berättelsen är.",
		"Varför säger du så?",
		"Strängt taget ljuger inte nyheten, men den nämner nästan inget om bakgrunden eller sammanhanget till bilden.",
		"Två unga män attackerar en svart man och visar upp sitt “resultat”, eller hur?",
		"När vi ser en misstänkt bild på sociala medier kan det vara en idé att fråga AI.",
		"@grok, är det sant?"
	]
	dialog_system()
	current_news_code = 1
	var casefile1_inst = casefile1.instantiate()
	casefile1_inst.position = Vector2(570, 300)
	add_child(casefile1_inst)
	
func set_newsfile1():
	current_news_code = 1
	var newsfile1_inst = newsfile1.instantiate()
	newsfile1_inst.news_pro_pos = Vector2(200, 300)
	newsfile1_inst.news_con_pos = Vector2(800, 300)
	newsfile1_inst.position = Vector2(570, 1500)
	add_child(newsfile1_inst)
	newsfile1_inst.name = "NewsFileInst1"
	
	#文件袋滑入桌子
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(newsfile1_inst, "position", Vector2(570, 460), 1).from_current()
	tween.tween_property(newsfile1_inst, "rotation", 0, 1).from(-0.3)
	tween.set_parallel(false)
	
	await tween.finished
	newsfile1_inst.slide_abit()
	
	
func set_newsfile2():	
	print("Is it trrue")
	current_news_code = 2
	destroy_newsfile(1)
	#摧毁上一个新闻
	#if has_node("NewsFileInst2"):
		#get_node("NewsFileInst2").queue_free()
		#for i in $NewspaperGroup.get_children():
			#i.queue_free()

	var newsfile2_inst = newsfile2.instantiate()
	newsfile2_inst.position = Vector2(570, 420)
	add_child(newsfile2_inst)
	newsfile2_inst.name = "NewsFileInst2"
	
	#文件袋滑入桌子
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(newsfile2_inst, "scale", Vector2.ONE, 1).from(Vector2.ZERO)
	tween.tween_property(newsfile2_inst, "position", Vector2(570, 400), 1).from(Vector2(570, 100))
	tween.tween_property(newsfile2_inst, "rotation", 0, 1).from(-0.3)
	
	tween.set_parallel(false)
	
	#摧毁新手教学
	tween.tween_property($SelectTutorial, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).from(Color(1.0, 1.0, 1.0, 1.0))
	await tween.finished
	$SelectTutorial.hide()

func set_newsfile3():
	#current_news_code = 3
	##摧毁上一个新闻
	destroy_newsfile(2)
	
	var newsfile3_inst = newsfile3.instantiate()
	newsfile3_inst.news_pro_pos = Vector2(200, 300)
	newsfile3_inst.news_con_pos = Vector2(800, 300)
	newsfile3_inst.position = Vector2(570, 1500)
	add_child(newsfile3_inst)
	newsfile3_inst.name = "NewsFileInst3"
	
	
	# Glida in pa
	#文件袋滑入桌子
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(newsfile3_inst, "position", Vector2(570, 440), 1).from_current()
	tween.tween_property(newsfile3_inst, "rotation", 0, 1).from(-0.3)
	tween.set_parallel(false)
	
	await tween.finished
	newsfile3_inst.slide_abit()
	#final_round = true
	


func set_newsfile5():
	current_news_code = 5
	destroy_newsfile(3)
	#摧毁上一个新闻
	#if has_node("NewsFileInst2"):
		#get_node("NewsFileInst2").queue_free()
		#for i in $NewspaperGroup.get_children():
			#i.queue_free()

	var newsfile5_inst = newsfile5.instantiate()
	newsfile5_inst.position = Vector2(570, 400)
	add_child(newsfile5_inst)
	newsfile5_inst.name = "NewsFileInst5"
	
	#文件袋滑入桌子
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(newsfile5_inst, "scale", Vector2.ONE, 1).from(Vector2.ZERO)
	tween.tween_property(newsfile5_inst, "position", Vector2(570, 460), 1).from(Vector2(570, 100))
	tween.tween_property(newsfile5_inst, "rotation", 0, 1).from(-0.3)
	tween.set_parallel(false)


func set_newsfile6():
	#current_news_code = 6
	##摧毁上一个新闻
	destroy_newsfile(5)
	
	var newsfile6_inst = newsfile6.instantiate()
	newsfile6_inst.news_pro_pos = Vector2(200, 300)
	newsfile6_inst.news_con_pos = Vector2(800, 300)
	newsfile6_inst.position = Vector2(570, 1500)
	add_child(newsfile6_inst)
	newsfile6_inst.name = "NewsFileInst6"
	
	
	# Glida in pa
	#文件袋滑入桌子
	var tween = create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(newsfile6_inst, "position", Vector2(570, 460), 1).from_current()
	tween.tween_property(newsfile6_inst, "rotation", 0, 1).from(-0.3)
	tween.set_parallel(false)
	
	await tween.finished
	newsfile6_inst.slide_abit()
	#final_round = true
	
	
	
	
	
	
################################################################################
func inspect_map():
	desk_down(false)
	
func set_news_property_with_timer(x: int):
	pass
	
	
	
	
func click_newspaper(code_string: String):
	match code_string:
		"news1_con":
			destroy_newsfile(1)
			map_gap()
			
			set_news_property_with_timer(-1)
			
		"news1_pro":
			destroy_newsfile(1)
			map_gap()
			set_news_property_with_timer(1)
		
		#interview
		"news2_con":
			destroy_newsfile(2)
			map_gap()
			set_news_property_with_timer(-1)
			#map_news_unreceived signal可以将改变是否能给地图变颜色
			Global.emit_signal("map_news_unreceived")
		"news2_pro":
			destroy_newsfile(2)
			map_gap()
			set_news_property_with_timer(1)
			print("news3_pro")
			Global.emit_signal("map_news_unreceived")
		
		
		"news3_con":
			destroy_newsfile(3)
			map_gap()
			set_news_property_with_timer(-1)
			#map_news_unreceived signal可以将改变是否能给地图变颜色
			Global.emit_signal("map_news_unreceived")
			
		"news3_pro":
			destroy_newsfile(3)
			map_gap()
			#set_news_property_with_timer(1)
			print("news3_pro")
			Global.emit_signal("map_news_unreceived")
		
		
				#interview
		"news5_con":
			destroy_newsfile(5)
			map_gap()
			#set_news_property_with_timer(-1)
			#map_news_unreceived signal可以将改变是否能给地图变颜色
			Global.emit_signal("map_news_unreceived")
		"news5_pro":
			destroy_newsfile(5)
			map_gap()
			#set_news_property_with_timer(1)
			print("news5_pro")
			Global.emit_signal("map_news_unreceived")
			
		
		"news6_con":
			Global.emit_signal("map_news_unreceived")
			
			destroy_newsfile(6)
			map_gap()
			#set_news_property_with_timer(-1)
			#pass
		"news6_pro":
			Global.emit_signal("map_news_unreceived")

			destroy_newsfile(6)
			map_gap()
			#set_news_property_with_timer(1)
			#pass
			
			
		

var news1_threat_dialog: bool = false
var news2_threat_dialog: bool = false
func hang_newspaper(code_string: String):
	match code_string:
		"news1_con":
			if news1_threat_dialog == true:
				return
			news1_threat_dialog = true
			
				
		"news1_pro":
			if news1_threat_dialog == true:
				return
			news1_threat_dialog = true

		"news2_con":
			if news2_threat_dialog == true:
				return
			news2_threat_dialog = true
			

		"news2_pro":
			pass
			


# judge 的对话气泡聊天系统
var dialog_z_index: int = 3
func dialog_say_something(dialog_char_num: int, dialog_content: String):
	match dialog_char_num:
		1:
			var tween1 = create_tween()
			tween1.tween_property($Judge/Graznovia/DialogBubble, "scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
			$Judge/Graznovia/DialogBubble/Content.text = dialog_content
			$Judge/Graznovia/DialogBubble/Content.z_index = dialog_z_index
		0:
			var tween2 = create_tween()
			tween2.tween_property($Judge/Eagalnia/DialogBubble, "scale", Vector2.ONE, 0.25).from(Vector2.ZERO)
			$Judge/Eagalnia/DialogBubble/Content.text = dialog_content
			$Judge/Eagalnia/DialogBubble/Content.z_index = dialog_z_index
			
	dialog_z_index += 1
var is_newsfile1_shown: bool = false
var is_casefile1_shown: bool = false
#var is_newsfile2_shown: bool = true
var dialog_number: int = 0

var dialog_all_pool: Array = [
	"Precis. Även om en bild inte är manipulerad kan den ändå ligga långt från verkligheten.", 
	"Faktum är att många bilder kan vara vilseledande och få oss att dra fel slutsatser.",
	"Därför borde vi inte bara lita på det vi ser direkt.",
	"Vi bör också kolla bakgrunden, källan och hur bilden används.",
	"Den här bilden är ett bra exempel.",
	]
	
func dialog_system():
	allow_talk_click = false
	$Judge/ClickTimer.start()
	if dialog_number > dialog_all_pool.size() - 1:
		#隐藏跳过键
		$Judge/SkipBtn.hide()
		
		#对话超出size时候tween的大小变为0
		var timer = Timer.new()
		timer.wait_time = 0.6
		get_node("Judge").add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
			
		var tween = create_tween()
		tween.tween_property($Judge/Eagalnia/DialogBubble, "scale", Vector2.ZERO, 0.25)
		tween.tween_property($Judge/Graznovia/DialogBubble, "scale", Vector2.ZERO, 0.25)
		if is_casefile1_shown != true:
			is_casefile1_shown = true
			
			desk_raise()
			set_casefile1()
			return
		else:
			Global.emit_signal("show_case1_puzzle_bg")
		return
		
	dialog_say_something(dialog_number % 2, dialog_all_pool[dialog_number])
	check_dialog_event(dialog_number)
	dialog_number += 1


var show_water_pic_page: int = 11
var dissolve_case_pic_page: int = 12
func check_dialog_event(dia_num: int):
	match dia_num:
		show_water_pic_page:
			Global.emit_signal("case1_waterpic_paper_show")
		dissolve_case_pic_page:
			Global.emit_signal("case1_gunpic_paper_dissolve")
			Global.emit_signal("case1_waterpic_paper_dissolve")

			
			
var tutorial_over: bool = false
func _unhandled_input(event):
	if event.is_action_pressed("ui_click") or event.is_action_pressed("ui_accept"):
		if allow_talk_click != true:
			return
		$Judge/ClickSound.play()
		dialog_system()
	if Input.is_action_pressed("ui_accept"):
		if $SelectTutorial.visible != true or tutorial_over == true:
			return
		#$SelectTutorial/HintsLabel.text = "Good Job"
		$SelectTutorial/HintsLabel.text = "Well done"
		
		
		$SelectTutorial/AnimatedSprite2D.show()
		
		var timer = Timer.new()
		timer.wait_time = 1.5
		get_node("Judge").add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
		#$SelectTutorial/HintsLabel.text = "Now, try to find two opposite\n
											#perspective in this photo"
		$SelectTutorial/HintsLabel.text = "Try to discover two completely \n
											 opposing parts from this photo."

		tutorial_over = true
		
		var timer2 = Timer.new()
		timer2.wait_time = 5
		get_node("Judge").add_child(timer2)
		timer2.start()
		await timer2.timeout
		timer2.queue_free()
		#$SelectTutorial/HintsLabel.hide()
		
		var tween = create_tween()
		tween.tween_property($SelectTutorial/HintsLabel, "modulate", Color(1.0, 1.0, 1.0, 0.0), 2.0).from_current()
		await tween.finished
		$SelectTutorial/HintsLabel.hide()

#Newspaper shown
var newspaper1_pro_shown: bool = false
var newspaper1_con_shown: bool = false
var newspaper3_pro_shown: bool = false
var newspaper3_con_shown: bool = false
var newspaper6_pro_shown: bool = false
var newspaper6_con_shown: bool = false
	
func popout_filled_newspaper(code: int):
	var present_position: Vector2
	var newspaper
	var newspaper_node_name
	match code:
		1:
			if newspaper1_pro_shown == true:
				return
			newspaper1_pro_shown = true
			
			newspaper = newspaper1_pro
			present_position = Vector2(950, 450)
		2:
			if newspaper1_con_shown == true:
				return
			newspaper1_con_shown = true
			
			newspaper = newspaper1_con
			present_position = Vector2(200, 450)
		#News2 & 5 are interview, so not present here
		#News3 *2 pro and con
		5:
			if newspaper3_pro_shown == true:
				return
			newspaper1_pro_shown = true
			
			newspaper = newspaper3_pro
			present_position = Vector2(950, 450)
		6:
			if newspaper3_con_shown == true:
				return
			newspaper3_con_shown = true
			
			newspaper = newspaper3_con
			present_position = Vector2(200, 450)
			
			
		11:
			if newspaper6_pro_shown == true:
				return
			newspaper6_pro_shown = true
			
			newspaper = newspaper6_pro
			present_position = Vector2(950, 450)
		12:
			if newspaper6_con_shown == true:
				return
			newspaper6_con_shown = true
			
			newspaper = newspaper6_con
			present_position = Vector2(200, 450)
	if newspaper == null:
		return
	var newspaper_inst = newspaper.instantiate()
	get_node("NewspaperGroup").add_child(newspaper_inst)
	
	newspaper_inst.position = present_position
	newspaper_node_name = null
	#报纸滑进的动画
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(newspaper_inst, "position", present_position, 0.5).from(present_position + Vector2(0, 500))
	

func pop_a_leader_sprite(leadernum: int):
	if leadernum == 0:
		
		#借这个选中con news的时顺便把框选教程的animation sprite消了
		var tween = create_tween()
		tween.tween_property($SelectTutorial/AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).from(Color(1.0, 1.0, 1.0, 1.0))
		await tween.finished
		$SelectTutorial/AnimatedSprite2D.hide()
		
		#var tween = create_tween()
		#tween.tween_property($Judge/Putin, "position", Vector2(200, 80), 0.2).from(Vector2(200, 500))
		#
	elif leadernum == 1:
		pass
		



func create_a_timer(time: int):
	var timer = Timer.new()
	timer.wait_time = time
	get_node("Judge").add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	
var allow_talk_click: bool = false
func _on_click_timer_timeout():
	allow_talk_click = true


func update_political_tendency(value: int):
	PoliticalTendency.value += value
	
	#if final_round == true:
		#final()

func map_over():
	var timer = Timer.new()
	timer.wait_time = 1.6
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	
	final()

func final():
		#归零时检查结局
	#if PoliticalTendency.value <= 0:
		#get_tree().change_scene_to_file("res://Scene/Ending/ending_1.tscn")
	#elif PoliticalTendency.value >= 100:
		#get_tree().change_scene_to_file("res://Scene/Ending/ending_2.tscn")
	#else:
		#get_tree().change_scene_to_file("res://Scene/Ending/ending_3.tscn")
	get_tree().change_scene_to_file("res://Scene/Ending/ending_1.tscn")

func _on_skip_btn_pressed():
	$Judge/SkipBtn.hide()
	dialog_number = dialog_all_pool.size() - 1


func news_map_over():
	
	match current_news_code:
		1:
			desk_raise()
		2:
			desk_raise()
		3:
			desk_raise()
		4:
			desk_raise()
		5:
			desk_raise()
		6:
			desk_raise()
	#desk_raise()
	#desk_half_raise()
	
	match current_news_code:
		2:
			set_newsfile2()
		3:
			set_newsfile3()
		5:
			set_newsfile5()
		6:
			set_newsfile6()

