extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	flash()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://Scene/Scene/prologue.tscn")
		
func flash():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/Label2, "modulate:a", 0.4, 0.8).from(1.0)
	tween.tween_property($CanvasLayer/Label2, "modulate:a", 1.0, 0.8).from(0.4)
	tween.set_loops()
	
