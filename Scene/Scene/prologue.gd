extends Node2D

@onready var text_interval = $TextInterval
@onready var rich_text_label1 = $CanvasLayer/RichTextLabel1
@onready var rich_text_label2 = $CanvasLayer/RichTextLabel2
@onready var rich_text_label3 = $CanvasLayer/RichTextLabel3
@onready var back_ground_color = $CanvasLayer/BGColorRect


@export var motto1:String = "Photography by its nature is selective."
@export var motto2:String = "                                        It isolates a single moment, divorcing that moment from the moments before and after that possibly lead to adjusted meaning"
@export var author:String = "Hal Buell"

@export_file("*.tscn") var target_path:String


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/SkipBtn.modulate.a = 0.0
	Bgmsystem.stop_bgm()
	#Bgmsystem.play_bgm()

	basic_setting()
	
	await set_a_wait_timer(2)
	#play_prologue(motto1, rich_text_label1)
	#play_prologue(motto2, rich_text_label2)
	#color_reverse()
	
	skip_btn_reveal()
	await set_a_wait_timer(6)
	get_tree().change_scene_to_file(target_path)
	
func basic_setting():
	text_interval.wait_time = 0.05


	
func play_prologue(print_text: String, rich_text_label: RichTextLabel):
	for letter in print_text:
		await text_interval.timeout
		rich_text_label.append_text(letter)


func color_reverse():
	var tween = create_tween()
	tween.parallel().tween_property(back_ground_color, "color:r", 0.0, 10.0).from(1.0)
	tween.parallel().tween_property(back_ground_color, "color:g", 0.0, 10.0).from(1.0)
	tween.parallel().tween_property(back_ground_color, "color:b", 0.0, 10.0).from(1.0)
	
	
	tween.parallel().tween_property(rich_text_label1, "theme_override_colors/default_color:r", 1.0, 10.0).from(0.0)
	tween.parallel().tween_property(rich_text_label1, "theme_override_colors/default_color:g", 1.0, 10.0).from(0.0)
	tween.parallel().tween_property(rich_text_label1, "theme_override_colors/default_color:b", 1.0, 10.0).from(0.0)
	
	await set_a_wait_timer(12)
	
	play_prologue(author, rich_text_label3)
	
	await set_a_wait_timer(3)
	get_tree().change_scene_to_file(target_path)
	
	

func skip_btn_reveal():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/SkipBtn, "modulate:a", 1.0, 1.0).from(0.0)

func set_a_wait_timer(the_time: float):
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = the_time
	timer.one_shot = true
	timer.start()
	await timer.timeout


func _on_skip_btn_pressed():
	get_tree().change_scene_to_file(target_path)
