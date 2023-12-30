extends Node2D

@onready var levelSwitcher = $LevelSwitcher
signal BackToMainMenu
var currentLevel = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_switcher_level_loaded():
	pass


func _on_button_button_up():
	BackToMainMenu.emit()
	get_child(get_children().size()-1).queue_free()

func loadNextLevel():
	currentLevel += 1
	get_child(get_children().size()-1).queue_free()
	levelSwitcher.loadLevel(currentLevel)

func _on_level_switcher_level_index_out_of_range():
	currentLevel = 0
	get_child(get_children().size()-1).queue_free()
	BackToMainMenu.emit()


func _on_main_menu_play():
	levelSwitcher.loadLevel(currentLevel)


func _on_main_menu_reset_progress():
	currentLevel = 0
