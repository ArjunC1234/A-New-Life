extends RigidBody2D
@onready var timer = $EventTimer
@onready var sprite_2d = $AnimatedSprite2D
@onready var camera = $"../Level/Camera2D"
@onready var coolDown = $moveCoolDown
@export var SPEED = 100
@onready var player = $"../Level/CharacterBody2D"

var allowMovement = false
var actionIndex = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(1)
	print("timerstarted")

func _on_event_timer_timeout():
	if actionIndex == 1:
		print("movement work!")
		sprite_2d.animation = "awake"
		allowMovement = true
	if actionIndex == 0:
		print("woah")
		sprite_2d.animation = "wake_up"
		actionIndex += 1
		timer.start(2)


func _process(delta):
	if (allowMovement):
		if Input.is_action_pressed("right"):
			apply_central_impulse(Vector2(SPEED, -SPEED))
			allowMovement = false
			coolDown.start()
			
		if Input.is_action_pressed("left"):
			apply_central_impulse(Vector2(-SPEED, -SPEED))
			allowMovement = false
			coolDown.start()
			
func isPlayer():
	pass
	
func updateCharms(charmToPass):
	player.updateCharms(charmToPass)
	queue_free()
	

func _on_move_cool_down_timeout():
	allowMovement = true
