extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("selected_city_signal", process_city_selection)


var start_city
func process_city_selection(city_node):
	if start_city != null:
		if city_node == start_city:
			start_city = null
		else:
			
			#执行飞行
			var angle = (city_node.global_position - start_city.global_position).angle()
			$plane.rotation = angle
			
			jet_emerged()
			
			var tween = create_tween()
			tween.tween_property($plane, "position", city_node.global_position, 1).from(start_city.global_position)
			await tween.finished
			jet_diminished()
			
			
			#reset
			get_tree().call_group("city", "reset_to_unselected")
			start_city = null
	else:
		start_city = city_node
		
func jet_emerged():
	var tween = create_tween()
	tween.tween_property($plane, "modulate:a", 1.0, 0.5).from(0.0)
	await tween.finished
	
func jet_diminished():
	var tween = create_tween()
	tween.tween_property($plane, "modulate:a", 0.0, 0.5).from(1.0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	pass


