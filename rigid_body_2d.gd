extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var collisionShape = $CollisionShape2D
@export var SPEED = 1000
var allowMovement = true
var rollJustStarted = true
var jumpTicks = 0;
signal emitNewLocation(pos)
# Called when the node enters the scene tree for the first time.
func _ready():
	sleeping = true
	freeze = true
	collisionShape.disabled = true
	position = Vector2(0, 0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_character_body_2d_roll_started(pos):
	if rollJustStarted:
		sleeping = false
		freeze = false
		collisionShape.disabled = false
		position = pos
		rollJustStarted = not rollJustStarted
	if (allowMovement):
		if Input.is_action_pressed("right"):
			apply_central_impulse(Vector2(SPEED, -SPEED))
		if Input.is_action_pressed("left"):
			apply_central_impulse(Vector2(-SPEED, -SPEED))
		allowMovement = false
		await get_tree().create_timer(1).timeout
		allowMovement = true



func _on_character_body_2d_roll_ended():
		sleeping = true
		freeze = true
		rollJustStarted = true
		collisionShape.disabled = false
		emitNewLocation.emit(position)
		position = position
