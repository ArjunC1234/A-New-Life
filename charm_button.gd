extends Button

signal SendCharmDict(d)
@export var charmDict = {}
@onready var glow = $PointLight2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled == true and charmDict.size() > 0:
		disabled = false
		self_modulate = charmDict.color
		glow.color = charmDict.color
		


func _on_button_up():
	if not disabled:
		SendCharmDict.emit(charmDict)
