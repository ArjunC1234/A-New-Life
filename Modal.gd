extends Control



@export var isVisible = false
@export var fadeLength = 1
@onready var fadeTimer = $fade

var fadingIn = false
var fadingOut = false
var color = Color(1, 1, 1, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate = color
	if fadingIn:
		color.a = (fadeTimer.wait_time - fadeTimer.time_left)/fadeTimer.wait_time
	elif fadingOut:
		color.a = fadeTimer.time_left/fadeTimer.wait_time

func fadeIn():
	fadingIn = true
	fadingOut = false
	visible = true
	fadeTimer.start(fadeLength)
	
	
func fadeOut():
	fadingIn = false
	fadingOut = true
	fadeTimer.start(fadeLength)

func _on_fade_timeout():
	if fadingIn and not fadingOut:
		fadingIn = false
		isVisible = true
	elif fadingOut and not fadingIn:
		isVisible = false
		visible = false
		fadingOut = false
