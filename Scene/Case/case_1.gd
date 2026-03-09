extends Node2D

var gun_pic: Vector2
var water_pic: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	$PuzzleBG.hide()
	$WaterPic.hide()
	$Illustration.hide()
	Global.connect("case1_waterpic_paper_show", show_water_pic)
	Global.connect("show_case1_puzzle_bg", show_bg)

func show_water_pic():
	$WaterPic.show()

func show_bg():
	$PuzzleBG.show()
	
func debris_finished_status():
	if $PuzzleBG/Debris1.visible == true and $PuzzleBG/Debris2.visible == true:
		$PuzzleBG.show()
		$PuzzleBG/Debris1.hide()
		$PuzzleBG/Debris2.hide()
		$PuzzleBG/AddIcon1.hide()
		$PuzzleBG/AddIcon2.hide()
		$PuzzleBG/Original.show()
		$Illustration.show()
		
		var timer = Timer.new()
		timer.wait_time = 3
		add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
		
		get_tree().change_scene_to_file("res://Scene/Scene/main_scene_chapter2.tscn")


