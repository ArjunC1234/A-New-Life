extends CanvasLayer
signal Play
signal ResetProgress

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reset_progress_button_up():
	ResetProgress.emit()


func _on_play_button_up():
	Play.emit()




func _on_level_switcher_level_loaded():
	visible = false


func _on_main_scene_back_to_main_menu():
	visible = true
