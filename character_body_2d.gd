extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jSusTimerFinished = false
@onready var jSusTimer = $JumpSustainTimer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	jump()

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	move_and_slide()
	
func jump():
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jSusTimer.stop()
		jSusTimerFinished = false
		jSusTimer.start(0.1)
	if Input.is_action_just_released("up") and not jSusTimerFinished:
		jSusTimer.stop()
		jSusTimerFinished = true
	if Input.is_action_pressed("up") and not jSusTimerFinished:
		velocity.y *= 1.15


func _on_jump_sustain_timer_timeout():
	jSusTimerFinished = true
