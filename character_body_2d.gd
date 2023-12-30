extends CharacterBody2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var jSusTimer = $JumpSustainTimer
@onready var dashTimer = $dashingTimer
@onready var wallJumpTimer = $wallJumpTimer
@onready var attackTimer = $AttackTimer
@onready var collisionShape = $CollisionShape2D
@onready var unfreeze = $unfreeze
@onready var dashDelay = $dashDelay
@export var health = 10
@export var damage = 5

var charms = []

signal updateHealth(h)
signal rollStarted(pos)
signal rollEnded
signal coinChange(coins)
signal addCharmsToHUD(c)
signal attackFlip(direction)
signal attack

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const dashEchoPath = preload('res://dash_effect.tscn')
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var echoCounts = 8
var echoIndex = 1
var echosSpawned = 0
var jSusBaseVelocityIncrease = 40
var jSusTimerFinished = false
var wall_jump_pushback = 200
var knockback = 400
var coinsCounter = 0
@onready var knownCheckpoints = [{"pos": position, "priority": 0, name: 'The Beginning'}]
@onready var lastCheckpoint = {"pos": position, "priority": 0, name: 'The Beginning'}
var doGravity = true
var allowJump = true
var allowMove = true
var isJump = false
var frozen = false
var state = "falling"
var fallPoint = position.y
var doJumpSustain = false

#CharmAbilityBooleans
var allowBallRoll = false
var allowJumpSustain = false
var allowAttack = false
var allowWallJump = false
var allowDash = false

var attacking = false

func _physics_process(delta):
	# Add the gravity.
	updateHealth.emit(health)
	if not frozen:
		if doGravity == true:
			if not is_on_floor():
				velocity.y += gravity * delta

		# Signal Jump
		if allowJump == true:
			jump()
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction < 0:
			sprite_2d.flip_h = true
			attackFlip.emit(-1)
		elif direction > 0:
			sprite_2d.flip_h = false
			attackFlip.emit(1)
		if allowMove:
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
				velocity.x = move_toward(velocity.x, 0, 80)
		dash()
		
		if sprite_2d.animation == "land" and not sprite_2d.is_playing() and state == "falling":
			state = "ground"
		
		if Input.is_action_just_pressed("space") and not attacking and attackTimer.is_stopped() and allowAttack:
			print("Hello")
			attacking = true
			sprite_2d.animation = "attack"
			attackTimer.start()
		move_and_slide()
		if not attacking:
			if not dashing:
				if is_on_floor():
					if state == "jumping":
						velocity.y = 0
						state = "falling"
					if state == "falling":
						if position.y - fallPoint > 300:
							sprite_2d.animation = "land"
							sprite_2d.play()
						else:
							state = "ground"
					if state == "ground":
						fallPoint = position.y
						if velocity.x == 0:
							sprite_2d.animation = "idle"
							sprite_2d.play()
						else:
							sprite_2d.animation = "run"
							sprite_2d.play()
				else:
					if velocity.y > 0:
						if velocity.y == 90:
							sprite_2d.animation = "wallSlide"
						else:
							sprite_2d.animation = "fall"
						state = "falling"
				if state == "jumping":
					sprite_2d.animation = "jump"
					state = "jumping"
					fallPoint = position.y
		
	
func checkRoll():
	if Input.is_action_pressed("space"):
		rollStarted.emit(position)
		sprite_2d.visible = true
		collisionShape.disabled = true
		freezeCharacter()
		
	if Input.is_action_just_released("space"):
		rollEnded.emit()
		unfreezeCharacter()
		sprite_2d.visible = true
		collisionShape.disabled = false
	#Jump Logic
func jump():
	if Input.is_action_just_pressed("up") and is_on_floor():
		#Initial Boost of the Jump
		velocity.y = JUMP_VELOCITY
		jSusTimer.stop()
		jSusTimerFinished = false
		state = "jumping"
		if not attacking:
			sprite_2d.animation = "jump"
			sprite_2d.play()
		#How Long Jump Sustain Lasts (Time is on slider)
		jSusTimer.start()
	if (Input.is_action_pressed("right") or Input.is_action_pressed("left")) and not is_on_floor() and is_on_wall() and allowWallJump and not dashing:
		if velocity.y >= 90:
			velocity.y = 90
		if Input.is_action_just_pressed("up"):
			sprite_2d.animation = "jump"
			sprite_2d.play()
			velocity.y = JUMP_VELOCITY/1.5
			jSusTimer.stop()
			jSusTimerFinished = false
			freezeCharacter()
			wallJumpTimer.start()
			#How Long Jump Sustain Lasts (Time is on slider)
			jSusTimer.start()
			state = "jumping"
			if Input.is_action_pressed("right"):
				velocity.x = -1 * wall_jump_pushback
			if Input.is_action_pressed("left"):
				velocity.x = wall_jump_pushback
				
	if Input.is_action_just_released("up") and not jSusTimerFinished:
		jSusTimer.stop()
		jSusTimerFinished = true
		
	if Input.is_action_pressed("up") and not jSusTimerFinished and allowJumpSustain:
		#Base Velocity Increase  * Ratio of Time Left vs Total Time to Wait (0-100%)
		#Effect: Gradually lowers the amount added to velocity based on how long the jump has been held.
		velocity.y += (-jSusBaseVelocityIncrease * jSusTimer.time_left/jSusTimer.wait_time)
		#velocity.y *= 1.17

func isPlayer():
	pass
#set jump sustain timer to finished after timer is finished.
func _on_jump_sustain_timer_timeout():
	jSusTimerFinished = true
	
#Collect Coin
func getCoin():
	coinsCounter += 1
	coinChange.emit(coinsCounter)

func save_checkpoint(checkpoint):
	lastCheckpoint = checkpoint
	knownCheckpoints.append(checkpoint)
	
func updateCharms(charm):
	charms.append(charm)
	if charm.name == "Charm of the Spirit":
		allowBallRoll = true
	if charm.name == "Charm of Ascension":
		allowJumpSustain = true
	if charm.name == "Charm of Bludgeoning":
		allowAttack = true
	if charm.name == "Charm of Propulsion":
		allowWallJump = true
	if charm.name == "Charm of Evasion":
		allowDash = true
		
	addCharmsToHUD.emit(charm)
	
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
	if is_on_floor() and dashDelay.is_stopped():
		if dashing == false:
			canDash = true
		
	if is_on_wall() and dashing:
		dashing = false
		unfreezeCharacter()
		velocity = dashDirection.normalized() * 100
		
	if Input.is_action_pressed("right"):
		dashDirection = Vector2(1,0)
		
	if Input.is_action_pressed("left"):
		dashDirection = Vector2(-1,0)
		
	if Input.is_action_just_pressed("dash"):
		if canDash == true and not attacking:
			sprite_2d.animation = "dash"
			canDash = false
			dashing = true
			freezeCharacter()
			dashDelay.start()
			
			
	if dashing:
		create_dash_echos()
	
func _on_dash_delay_timeout():
	pass # Replace with function body.
	#add animation for dashing here
	velocity = dashDirection.normalized() * 1500
	echoIndex = 1
	dashTimer.start()
	

func create_dash_echos():

	#If Time Passed > Total Time times Echos passed divided by Total Echos
	if ((dashTimer.wait_time - dashTimer.time_left) >= (echoIndex * dashTimer.wait_time)/echoCounts):
		echoIndex += 1
		var echo = dashEchoPath.instantiate()
		get_parent().add_child(echo)
		echo.position = position
		echo.flip_h = sprite_2d.flip_h


func _on_dash_timer_timeout():
	dashing = false
	unfreezeCharacter()
	velocity = dashDirection.normalized() * 100
	
func refreshDash():
	canDash = true


func _on_wall_jump_timer_timeout():
	unfreezeCharacter()


func _on_rigid_body_2d_emit_new_location(pos):
	position = pos

func take_damage(amount, vector, attackerNode):
	if unfreeze.is_stopped() and not dashing and not frozen:
		velocity = vector.normalized() * knockback
		freezeCharacter()
		unfreeze.start()
		health -= amount
		if (health <= 0):
			position = lastCheckpoint.pos
			velocity = Vector2(0, 0)
			health = 10



func _on_animated_sprite_2d_animation_finished():
	if sprite_2d.animation == "attack":
		attacking = false
		attack.emit()
		


func _on_unfreeze_timeout():
	unfreezeCharacter()


func _on_dialogue_hud_started_dialogue_sequence():
	frozen = true
	sprite_2d.pause()


func _on_dialogue_hud_finished_dialogue_sequence():
	frozen = false
	sprite_2d.play()


