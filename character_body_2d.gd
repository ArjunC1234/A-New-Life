extends CharacterBody2D
@onready var sprite_2d = $Sprite2D
@onready var jSusTimer = $JumpSustainTimer
@onready var dashTimer = $dashingTimer
@onready var wallJumpTimer = $wallJumpTimer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jSusBaseVelocityIncrease = 40
var jSusTimerFinished = false
var wall_jump_pushback = 300

var coinsCounter = 0

var doGravity = true
var allowJump = true
var allowMove = true
var isJump = false

func _physics_process(delta):
	# Add the gravity.
	if doGravity == true:
		if not is_on_floor():
			velocity.y += gravity * delta

	# Signal Jump
	if allowJump == true:
		jump()

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if allowMove:
		var direction = Input.get_axis("left", "right")
		if direction:
			if is_on_floor():
				velocity.x = direction * SPEED
			else:
				velocity.x += direction * (SPEED/25)
				if (abs(velocity.x)>SPEED):
					if velocity.x < 0:
						velocity.x = -SPEED
					else:
						velocity.x = SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 50)
			

	
	
	move_and_slide()
	
	dash()
	
	
	
	#Jump Logic
func jump():
	if Input.is_action_just_pressed("up") and is_on_floor():
		#Initial Boost of the Jump
		velocity.y = JUMP_VELOCITY
		
		jSusTimer.stop()
		jSusTimerFinished = false
		
		#How Long Jump Sustain Lasts (Time is on slider)
		jSusTimer.start()
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and not is_on_floor() and is_on_wall():
		if velocity.y >= 90:
			velocity.y = 90
		if Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY
			jSusTimer.stop()
			jSusTimerFinished = false
			freezeCharacter()
			wallJumpTimer.start()
			#How Long Jump Sustain Lasts (Time is on slider)
			jSusTimer.start()
			if Input.is_action_pressed("right"):
				velocity.x = -1 * wall_jump_pushback
			if Input.is_action_pressed("left"):
				velocity.x = wall_jump_pushback
				
	if Input.is_action_just_released("up") and not jSusTimerFinished:
		jSusTimer.stop()
		jSusTimerFinished = true
		
	if Input.is_action_pressed("up") and not jSusTimerFinished:
		#Base Velocity Increase  * Ratio of Time Left vs Total Time to Wait (0-100%)
		#Effect: Gradually lowers the amount added to velocity based on how long the jump has been held.
		velocity.y += (-jSusBaseVelocityIncrease * jSusTimer.time_left/jSusTimer.wait_time)
		#print(-jSusBaseVelocityIncrease * jSusTimer.time_left/jSusTimer.wait_time)
		#velocity.y *= 1.17


#set jump sustain timer to finished after timer is finished.
func _on_jump_sustain_timer_timeout():
	jSusTimerFinished = true
	
#Collect Coin
func getCoin():
	coinsCounter += 1
	print (coinsCounter)
	
#Movements to Allow, Freeze, Whatever
func freezeCharacter():
	doGravity = false
	allowJump = false
	allowMove = false
	
func unfreezeCharacter():
	doGravity = true
	allowJump = true
	allowMove = true
	
	
	


#Dash
var dashDirection = Vector2(1,0)
var canDash = false
var dashing = false
	
func dash():
	if is_on_floor():
		if dashing == false:
			canDash = true
		
	if Input.is_action_pressed("right"):
		dashDirection = Vector2(1,0)
		
	if Input.is_action_pressed("left"):
		dashDirection = Vector2(-1,0)
		
	if Input.is_action_just_pressed("dash"):
		if canDash == true:
			canDash = false
			dashing = true
			freezeCharacter()
			#add animation for dashing here
			velocity = dashDirection.normalized() * 1500
			dashTimer.start()

func _on_dash_timer_timeout():
	dashing = false
	unfreezeCharacter()
	velocity = dashDirection.normalized() * 100
	
func refreshDash():
	canDash = true


func _on_wall_jump_timer_timeout():
	unfreezeCharacter()
