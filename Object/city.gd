extends Node2D
class_name CityNode


var city_selected: bool = false

@export var city_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		$Label.show()
		if event.button_index == 1 and event.is_pressed():
			select_city()

func reset_to_unselected():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2).from(Vector2.ONE * 0.8)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).from_current()
	city_selected = false
	
	
	
func select_city():
	if city_selected == true:
		reset_to_unselected()
		Global.emit_signal("selected_city_signal", self)
		return
		
	city_selected = true
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2).from(Vector2.ONE * 1.2)
	tween.tween_property(self, "modulate:a", 0.5, 0.2).from(1.0)
	Global.emit_signal("selected_city_signal", self)
	

				


func _on_area_2d_mouse_entered():
	$Control/Label.show()


func _on_area_2d_mouse_exited():
	$Control/Label.hide()
