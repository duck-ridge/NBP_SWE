extends Node2D

var gun_pic: Vector2
var water_pic: Vector2

var is_show_bg: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$PuzzleBG.hide()
	$WaterPic.hide()
	$GunPic.hide()
	$PuzzleBG/Original.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Illustration.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.connect("case1_waterpic_paper_show", show_water_pic)
	Global.connect("show_case1_puzzle_bg", show_bg)
	
	show_gun_pic()

func show_water_pic():
	$WaterPic.show()
	$WaterPic.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property($WaterPic, "scale", Vector2.ONE, 0.4)
	
func show_gun_pic():
	$GunPic.show()
	$GunPic.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property($GunPic, "scale", Vector2.ONE, 0.4)
	
func show_bg():
	if is_show_bg == true:
		return
	is_show_bg = true
	$PuzzleBG.show()
	$PuzzleBG.position = Vector2(0, -500)
	var tween = create_tween()
	tween.tween_property($PuzzleBG, "position", Vector2.ZERO, 0.4)
	
	
func debris_finished_status():
	if $PuzzleBG/Debris1.visible == true and $PuzzleBG/Debris2.visible == true:
		$PuzzleBG.show()
		
		#$PuzzleBG/Debris1.hide()
		#$PuzzleBG/Debris2.hide()
		#$PuzzleBG/AddIcon1.hide()
		#$PuzzleBG/AddIcon2.hide()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property($PuzzleBG/BG, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
		tween.tween_property($PuzzleBG/Debris1, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
		tween.tween_property($PuzzleBG/Debris2, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
		tween.tween_property($PuzzleBG/AddIcon1, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
		tween.tween_property($PuzzleBG/AddIcon2, "modulate", Color(1.0, 1.0, 1.0, 0), 0.25)
		tween.set_parallel(false)
		tween.tween_property($PuzzleBG/Original, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25).from(Color(1.0, 1.0, 1.0, 0.0))
		tween.tween_property($Illustration, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.25).from(Color(1.0, 1.0, 1.0, 0.0))
		#$PuzzleBG/Original.show()
		#$Illustration.show()
		
		var timer = Timer.new()
		timer.wait_time = 5
		add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
		
		get_tree().change_scene_to_file("res://Scene/Scene/main_scene_chapter2.tscn")


