extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var speed = 200
@export var direction = 1
var collisions = []
@onready var raycast = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = speed*direction
	move_and_slide()
	collisions = []
	for i in raycast.get_slide_collision_count():
		var collision = raycast.get_slide_collision(i)
		collisions.append(collision.get_collider().name)
	if (is_on_wall() or not $RayCast2D.is_colliding()) and not ("Player" in collisions or "Enemy" in collisions):
		direction *= -1
		scale.x *= -1
