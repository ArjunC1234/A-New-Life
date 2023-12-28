extends Area2D
@onready var cooldown = $refreshTimer
@onready var sprite_2d = $AnimatedSprite2D
var active = true

func _on_body_entered(body):
	if active == true:
		if body.has_method("refreshDash"):
			body.refreshDash()
			sprite_2d.animation = "deactivate"
			sprite_2d.play()
			cooldown.start()
			active = false

func _on_refresh_timer_timeout():
	sprite_2d.animation = "default"
	active = true
