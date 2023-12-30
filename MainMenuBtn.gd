extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_switcher_level_loaded():
	visible = true


func _on_main_scene_back_to_main_menu():
	visible = false
