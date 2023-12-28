extends RigidBody2D


@export var SPEED = 1000
var allowMovement = true
var jumpTicks = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	queue_free()
	
func _physics_process(delta):
	if (allowMovement):
		if Input.is_action_pressed("right"):
			apply_central_impulse(Vector2(SPEED, -SPEED))
		if Input.is_action_pressed("left"):
			apply_central_impulse(Vector2(-SPEED, -SPEED))
		allowMovement = false
		await get_tree().create_timer(1).timeout
		allowMovement = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		
