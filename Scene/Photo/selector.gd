extends ColorRect

class_name Selector

var is_dragging :bool = false
var drag_start_pos : Vector2
var drag_end_pos : Vector2

signal selected_node(nodeArray:Array)

func _input(event):
	if event is InputEventMouseButton:
		if Global.is_dragging or Global.selected_pic:
			return
		if event.button_index == 1 and event.is_pressed():
			if is_dragging != true:
				is_dragging = true
				drag_start_pos = get_global_mouse_position()
				global_position = drag_start_pos
					
		elif event.is_pressed() == false:
			if is_dragging == true:
				is_dragging = false
				drag_end_pos = get_global_mouse_position()
				_press_ended()
				self.hide()
				self.size = Vector2.ZERO
				
	if event is InputEventMouseMotion:
		if is_dragging == true:
			self.show()
			_update()

func _update():
	scale = sign(get_global_mouse_position() - drag_start_pos) * Vector2.ONE
	size = (get_global_mouse_position() - drag_start_pos) * scale

func _press_ended():
	var node_to_get = get_tree().get_nodes_in_group("Selectable")
	var node_in_rect = []
	var rest_node = []
	
	var top_left_corner = _get_top_left_corner()
	var search_field : Rect2 = Rect2(top_left_corner.x, top_left_corner.y, abs(size.x), abs(size.y))
	
	if node_to_get != null:
		for node in node_to_get:
			#if get_global_rect().has_point(node.global_position):
			if search_field.has_point(node.global_position):
				node_in_rect.append(node)
				#node.scale = Vector2(0.55, 0.55)
		emit_signal("selected_node", node_in_rect)
		rest_node = arrayDifference(node_to_get, node_in_rect)
	for i in rest_node:
		#i.scale = Vector2(0.5, 0.5)
		pass
	
	
func arrayDifference(largerArray, smallerArray):
	var only_in_arr1 = []
	for v in largerArray:
		if not (v in smallerArray):
			only_in_arr1.append(v)
	return only_in_arr1


func _get_top_left_corner():
	var x = drag_start_pos.x if drag_start_pos.x <= drag_end_pos.x else drag_end_pos.x
	var y = drag_start_pos.y if drag_start_pos.y <= drag_end_pos.y else drag_end_pos.y
	return(Vector2(x,y))
