extends Node2D

@onready var peach_file = preload("res://Asset/UI/peach_file.png")
@onready var cyan_file = preload("res://Asset/UI/cyan_file.png")


var news_is_selected: bool = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var rng = randi_range(-1, 1)
		set_image(rng)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		switch_news_selected()

		pass

func show_reset():
	show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2.ONE * 4, 0.5).from(Vector2.ZERO)
	
	scale = Vector2.ONE * 4
	
	#
#func lowlight_the_news_button():
	#scale = Vector2.ONE * 0.75
		
func switch_news_selected():
	if news_is_selected == true:
		Global.emit_signal("is_toggling_news", false)
		news_is_selected = false
		print("JJJJJJ")
		#scale = Vector2.ONE * 0.75
	elif news_is_selected == false:
		Global.emit_signal("is_toggling_news", true)
		news_is_selected = true
		scale = Vector2.ONE * 1.25 * 4
		news_is_selected = false
	pass

#如果news_tendency是0那就隐身，如果大于1就用eagle的图，反之granz
func set_image(news_tendency):
	if news_tendency > 0:
		$Sprite2D.texture = peach_file
	elif news_tendency < 0:
		$Sprite2D.texture = cyan_file
	else:
		print("news tendency == 0")
	pass
