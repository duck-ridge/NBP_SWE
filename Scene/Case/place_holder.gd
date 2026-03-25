extends Node2D

var prove_pic1 = preload("res://Scene/Case/case2_widget/Proves/PROVESWE/Prove1.png")
var prove_pic2_1 = preload("res://Scene/Case/case2_widget/Proves/PROVESWE/Prove2_1.png")
var prove_pic2_2 = preload("res://Scene/Case/case2_widget/Proves/PROVESWE/Prove2_2.png")
var prove_pic3 = preload("res://Scene/Case/case2_widget/Proves/Prove3.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	pass
	
func take_prove(prove_num):
	match prove_num:
		1:
			$empty.texture = prove_pic1
			$Note.text = "Upplopp bryter ut i Detroit."
		2_1:
			$empty.texture = prove_pic2_1
			$Note.text = "Två unga män hjälper offret att resa sig."
		2_2:
			$empty.texture = prove_pic2_2
			$Note.text = "Två angripare visar stolt upp sitt “verk”."
		3:
			$empty.texture = prove_pic3
			$Note.text = "Två unga män eskorterar offret bort från platsen."
	get_node("..").check_news_order()
