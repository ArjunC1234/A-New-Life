extends Area2D

@onready var sprite_2d = $AnimatedSprite2D
@onready var light = $PointLight2D
@onready var removeTimer = $removeCharmTimer
@export var charm_color = Color(1, 0.2, 0.2)
@export var charm_name = "red"
@export_multiline var charm_description = "Charm Description Goes Here"
@export var charm_collected = false
@export var playerPathIfCharmCollected : NodePath
@export var include = false
@onready var animation = $AnimationPlayer


var entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("bob")
	add_to_group("charms")
	if charm_collected == true:
		var Player = get_node(playerPathIfCharmCollected)
		entered = true
		Player.updateCharms({'name' : charm_name, 'color' : charm_color, 'description' : charm_description})
	if not include or charm_collected:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite_2d.self_modulate = charm_color
	light.color = charm_color
	if not removeTimer.is_stopped():
		charm_color.a = removeTimer.time_left/removeTimer.wait_time
	

func _on_body_entered(body):
	if body.has_method("updateCharms") and entered == false:
		entered = true
		body.updateCharms({'name' : charm_name, 'color' : charm_color, 'description' : charm_description})
		removeTimer.start()


func _on_remove_charm_timer_timeout():
	queue_free()
