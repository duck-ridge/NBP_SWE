extends Node2D


@onready var newspaper_empty = preload("res://Object/newspaper.tscn")
@onready var paper_number: int = 6


func _ready():
	slide_in_paper(paper_number)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func slide_in_paper(pm: int):
	
	for i in pm:
		var rand_degree = randi_range(-20, 20)
		var np_inst = newspaper_empty.instantiate()
		add_child(np_inst)
		np_inst.position = Vector2(-800, 0)
		np_inst.rotation_degrees = rand_degree
		
		var tween = create_tween()
		tween.tween_property(np_inst, "position", Vector2(0, 0), 0.5).from(Vector2(-800, 0))
		await $SlideIntervalTimer.timeout
		continue
