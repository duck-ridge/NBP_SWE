extends Node

signal show_newspaper_title_button
signal newspaper_pic_placed(code: int)

signal filled_newspaper(code: int)

#选中一个图片时弹出领导人
signal pop_a_leader(leader_num: int)


#newspaper 悬浮
signal newspaper_hang(code: String)

#结算
signal end_settlement

#newspaper 选中
#code 1: news_con
signal newspaper_click(code: String)

signal change_progressbar_value(value: int)

var is_dragging: bool = false
var newspaper_pic_is_in_place: bool = false
var selected_pic
var selected_pic_code: int

var news1_photo_pro_shown: bool = false
var news1_photo_con_shown: bool = false
var news3_photo_pro_shown: bool = false
var news3_photo_con_shown: bool = false
var news6_photo_pro_shown: bool = false
var news6_photo_con_shown: bool = false


#map 已经收到宣传物料，之后禁止重复使用
signal map_news_received
signal map_news_unreceived
signal map_all_filled
signal is_dragging_news(state: bool, mouse_event_pos: Vector2)

signal is_toggling_news(toggled: bool)


signal case1_gunpic_paper_dissolve
signal case1_waterpic_paper_dissolve
signal case1_waterpic_paper_show
signal show_case1_puzzle_bg

signal case2_grok_show
signal case2_rating_show


#选中一个城市
signal selected_city_signal(city_node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
