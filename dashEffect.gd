extends Sprite2D
@export var defualtOpacity = 0.6
@export var transparencyRate = 0.04


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = defualtOpacity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a -= transparencyRate
	if modulate.a <= 0:
		print("deleted")
		queue_free()
