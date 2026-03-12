extends Node2D

var is_PL1_correct: bool = false
var is_PL2_correct: bool = false
var is_PL3_correct: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass
	
func prove_placed():
	pass
	
func check_news_order():
	print(is_PL1_correct)
	if is_PL1_correct == true and is_PL2_correct == true and is_PL3_correct == true:
		$ContinueButton.disabled = false
	
	
func _on_texture_button_pressed():
	get_tree().reload_current_scene()
