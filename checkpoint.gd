extends Area2D

@onready var torch = $Torch
@onready var torch2 = $Torch2
@onready var sprite = $AnimatedSprite2D
@export var save_priority = 0
@export var enabled = false


# Called when the node enters the scene tree for the first time.
func _ready():
	torch.lightOn=false
	torch2.lightOn=false
	sprite.animation = "default"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("save_checkpoint") and not enabled:
		var check_pos = position
		check_pos.y -= 40
		sprite.animation = "turnOn"
		enabled = true
		body.save_checkpoint({"pos": check_pos, "priority": save_priority})
		
		
		
func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "turnOn":
		torch.lightOn = true
		torch2.lightOn = true
