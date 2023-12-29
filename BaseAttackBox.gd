extends Area2D

var bodiesInBox = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	bodiesInBox.append(body)


func _on_body_exited(body):
	if bodiesInBox.size() > 1:
		for b in range(bodiesInBox.size()-1, 0, -1):
			if bodiesInBox[b].name == body.name:
				bodiesInBox.remove_at(b)
	elif bodiesInBox.size() == 1:
		if bodiesInBox[0].name == body.name:
			bodiesInBox.remove_at(0)		
			


func _on_character_body_2d_attack():
	var player = get_parent()
	for body in bodiesInBox:
		if body.has_method("take_damage"):
			body.take_damage(player.damage, body.position-player.position)


func _on_character_body_2d_attack_flip(direction):
	position.x = abs(position.x) * direction
