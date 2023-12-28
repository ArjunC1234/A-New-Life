extends Area2D

func _on_body_entered(body):
	if body.has_method("getCoin"):
		body.getCoin()
		queue_free()
