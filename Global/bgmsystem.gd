extends Node2D

@onready var audio = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainBGM.stop()
	
func play_bgm():
	audio.play()
	await audio.finished
	$MainBGM.play()

func stop_bgm():
	$MainBGM.stop()
	audio.stop()
