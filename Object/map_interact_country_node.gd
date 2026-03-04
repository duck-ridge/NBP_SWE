@tool
extends Node2D


var is_play_flashing: bool = false
#var state_propaganda_level: int = 0

# state_receive_level > 0 是红色
var state_receive_level: int = 0
var target_color: Color
var is_allow_input_news: bool = true
var is_occupied: bool = false

var news_card_is_selecting: bool = false
@export var state_map: Texture2D
@export var state_outline: PackedVector2Array



func _ready():
	Global.connect("map_news_received", forbiden_input_news)
	Global.connect("map_news_unreceived", access_input_news)
	
	modulate = Color(0.8, 0.8, 0.8, 1.0)
	pass_the_map_to_sprite()

func pass_the_map_to_sprite():
	$Sprite2D.texture = state_map
	#$Area2D/CollisionPolygon2D.polygon = state_outline
	
func forbiden_input_news():
	is_allow_input_news = false
	pass
func access_input_news():
	is_allow_input_news = true
	
func update_state_receive_level():
	color_blender(state_receive_level)
	
	
	
	

func _on_area_2d_mouse_entered():
	if news_card_is_selecting == false:
		return
	#if news_is_dragging != true:
		#return
	play_flashing()
	
	#if is_occupied:
		#return
	#if is_allow_input_news:
		#play_flashing()
		

func _on_area_2d_input_event(viewport, event, shape_idx):
	if news_card_is_selecting != true:
		return
	if is_occupied == true:
		return
	if is_allow_input_news != true:
		return
		
	#鼠标释放在area2d内部
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("RELEASE INSIDE")
		
		var tween = create_tween()
		tween.tween_property(self, "modulate", target_color, 0.5).from(Color(1.0, 1.0, 1.0, 1.0))
		modulate = target_color
		
		Global.emit_signal("map_news_received")
		is_occupied = true

func dragged(mouse_pos: Vector2):
	pass



func play_flashing():
	is_play_flashing = true
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE * 1.05, 0.5).from((Vector2.ONE))
	tween.tween_property($Sprite2D, "scale",Vector2.ONE, 0.5).from(Vector2.ONE * 1.05)
	await tween.finished
	is_play_flashing = false

func color_blender(a: int):
	#state_receive_level(宣传材料）变色
	if a > 0:
		#Peach
		target_color = Color(1.0, 0.7, 0.48, 1.0)
	elif a < 0:
		#Cyan
		target_color = Color(0.0, 0.74, 0.83, 1.0)
	else:
		target_color = Color(0.1, 0.1, 0, 1.0)
	
	

	
	





