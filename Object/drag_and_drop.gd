extends Node2D

var news_tendency: int
var is_map_all_filled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_news_property 排在第一
	#set_news_property(1)
	#set_drag_and_drop_element()
	#change_receive_level()
	Global.connect("map_news_received", check_state)
	#受到toggle_newsr信号：正在选中
	Global.connect("is_toggling_news", news_card_select)
	
	#$toggle_news.news_is_selected = false
	#$toggle_news.switch_news_selected()
	$toggle_news.hide()
	#受到MapInteractNewspaper信号：正在拖动
	#Global.connect("is_dragging_news", set_state_when_dragging)
	
func news_card_select(is_selected: bool):
	for city in $MapAll.get_children():
		city.news_card_is_selecting = is_selected
	
func change_receive_level():
	for i in $MapAll.get_children():
		i.state_receive_level = news_tendency
		i.update_state_receive_level()
		
		
func set_selectable_element():
	if $toggle_news.visible == false:
		#$toggle_news.news_is_selected = false
		Global.emit_signal("is_toggling_news", false)
		
		$toggle_news.show_reset()
	$toggle_news.set_image(news_tendency)
	
	
func set_news_property(num: int):
	news_tendency = num
	set_selectable_element()
	change_receive_level()
	
	
#看看是不是所有州都填满了如果是就call mainscene final结算
func check_state():
	var occupied_num:int = 0
	for i in $MapAll.get_children():
		if i.is_occupied == true:
			occupied_num += 1
	#if occupied_num >= $MapAll.get_child_count() - 1:
	print("----------------")
	print(occupied_num)
	print("----------------")
	if occupied_num >= 4:
		Global.emit_signal("map_all_filled")
		is_map_all_filled = true
	#$toggle_news.news_is_selected = false
	$toggle_news.hide()
	
