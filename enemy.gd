extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal flipH
@export var speed = 200
@export var direction = 1
@export var health = 10
@export var damage = 1
var collisions = []
var freeze = false
var knockback = 800
@onready var raycast = $RayCast2D
@onready var sprite_2d = $Sprite2D
@onready var unfreeze = $unfreeze
@onready var deathDelay = $deathDelay



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
		
func take_damage(amount, vector, attackerNode):
	freeze = true
	velocity = vector.normalized() * knockback
	unfreeze.start()
	health -= amount
	if (health <= 0):
		position = Vector2(-1000, -1000)
		if attackerNode.has_method("killEnemy"):
			attackerNode.killEnemy(name)
		deathDelay.start()
		
	


func _on_unfreeze_timeout():
	freeze = false


func _on_death_delay_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	print("body detected")
	if body.has_method("take_damage"):
		print('player detected')
		body.take_damage(damage, body.position - position, self)
