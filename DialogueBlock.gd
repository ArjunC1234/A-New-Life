extends Node


@export var profileImage : CompressedTexture2D
@export var textColor : Color = Color(1, 1, 1)
@export var author : String
@export_multiline var message : String
@export var timeout : float

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(get_parent().name + "/dialogue")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
