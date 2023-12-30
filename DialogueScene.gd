extends Area2D

@export var triggerAfterSeconds : float = 0.05
@export var was_triggered = false
@export var HUDNodePath : NodePath
@onready var HUD_node = get_node(HUDNodePath)

# Called when the node enters the scene tree for the first time.
func _ready():
	$TriggerAfter.wait_time = triggerAfterSeconds



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("isPlayer") and not was_triggered:
		$TriggerAfter.start(triggerAfterSeconds)
		was_triggered = true
	


func _on_trigger_after_timeout():
	var dArray = []
	for dialogue in get_tree().get_nodes_in_group(name + "/dialogue"):
		var dialogueObject = {
			"author" : dialogue.author,
			"message" : dialogue.message,
			"textColor" : dialogue.textColor,
			"profileImage" : dialogue.profileImage,
			"timeout" : dialogue.timeout
		}
		dArray.append(dialogueObject)
	
	HUD_node.triggerDialogue(dArray)
