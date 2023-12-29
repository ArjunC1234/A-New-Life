extends StaticBody2D

@onready var flick = $FlickerTimer
@onready var light = $PointLight2D
@onready var sprite_2d = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@export var enable_shadows: bool = false
@export var collidable: bool = true
@export var lightOn: bool = true

# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var targetTime

var startEnergy
var target_energy
var total_step
func _ready():
	startEnergy = light.energy
	target_energy = rng.randf_range(0.85, 1.1)
	total_step = startEnergy - target_energy
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light.enabled = lightOn
	collision.disabled = not collidable
	if light.enabled:
		sprite_2d.animation = "default"
		light.shadow_enabled = enable_shadows
		light.energy = startEnergy + ((flick.wait_time - flick.time_left)/flick.wait_time)*total_step
	else:
		sprite_2d.animation = "off"
	


func _on_flicker_timeout():
	startEnergy = target_energy
	target_energy = rng.randf_range(0.85, 1.1)
	total_step = target_energy - startEnergy
	targetTime = rng.randf_range(0.1, 0.4)
	flick.start(targetTime)
	
