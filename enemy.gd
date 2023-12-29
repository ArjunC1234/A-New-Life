extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal flipH
@export var speed = 200
@export var direction = 1
@export var health = 10
var collisions = []
var freeze = false
var knockback = 400
@onready var raycast = $RayCast2D
@onready var sprite_2d = $Sprite2D
@onready var unfreeze = $unfreeze



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		# Add the gravity.
		
	if (is_on_wall() or not $RayCast2D.is_colliding()) and is_on_floor():
		sprite_2d.flip_h = not sprite_2d.flip_h
		flipH.emit()
		direction *= -1
	if not is_on_floor():
		velocity.y += gravity * delta
	if not freeze:
		velocity.x = speed*direction
	move_and_slide()
		
func take_damage(amount, vector):
	freeze = true
	velocity = vector.normalized() * knockback
	unfreeze.start()
	health -= amount
	if (health <= 0):
		position = Vector2(-1000, -1000)
		queue_free()
	


func _on_unfreeze_timeout():
	freeze = false
