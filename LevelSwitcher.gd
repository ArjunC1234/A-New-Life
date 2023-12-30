extends Node

@export_dir var levelFolder
var levelFileNames
signal levelLoaded
signal levelIndexOutOfRange
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func loadLevel(index):
	levelFileNames = DirAccess.get_files_at(levelFolder)
	if levelFileNames.size() > index:
		var path = load(levelFolder + "/" + levelFileNames[index])
		print(path)
		get_tree().root.get_child(0).add_child(path.instantiate())
		print(get_tree().root.get_child(0).get_children())
		levelLoaded.emit()
	else:
		print("index out of range")
		levelIndexOutOfRange.emit()
		
