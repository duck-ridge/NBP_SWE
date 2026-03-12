extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$RiotPic/Grok.hide()
	$RiotPic/Context.hide()
	$ReliableList.hide()
	Global.connect("case2_grok_show", show_grok_comment)
	Global.connect("case2_rating_show", show_rating)
	Global.connect("case2_reader_context", show_reader_reminder)
	Global.connect("show_case2_SOLVE_IT", self_disappear)
func show_grok_comment():
	$RiotPic/Grok.show()
	
func show_rating():
	$ReliableList.show()
	
func show_reader_reminder():
	$RiotPic/Context.show()
	
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

func self_disappear():
	queue_free()
	
func _on__pressed():
	get_node("..").add_dialog_after_grok()
	$ReliableList.hide()
	get_node("..").dialog_system()
	get_node("..").allow_SOLVEIT = true
