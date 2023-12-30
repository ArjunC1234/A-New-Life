extends CanvasLayer

signal finishedDialogueSequence
signal startedDialogueSequence
var currentIndex = 0
var currentDialogueA = []
@onready var profileImage = $Modal/ProfileImage
@onready var author = $Modal/CenterContainer/VBoxContainer/Author
@onready var message = $Modal/CenterContainer/VBoxContainer/Message
@onready var changeModalTimer = $changeModal
@onready var modal = $Modal

@export var doDialogue = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func loadDialogueBlock(dBlock : Dictionary):
	author.label_settings.set_font_color(dBlock.textColor)
	message.label_settings.set_font_color(dBlock.textColor)
	author.text = dBlock.author
	message.text = dBlock.message
	profileImage.texture = dBlock.profileImage
	modal.fadeIn()


func triggerDialogue(dialogueArray):
	if (doDialogue):
		layer = 3
		currentDialogueA = dialogueArray
		currentIndex = 0
		if dialogueArray.size() > 0:
			startedDialogueSequence.emit()
			loadDialogueBlock(dialogueArray[currentIndex])
		
		
func _on_change_modal_timeout():
	modal.fadeOut()


func _on_modal_finished_fading_in():
	changeModalTimer.start(currentDialogueA[currentIndex].timeout)


func _on_modal_finished_fading_out():
	currentIndex+=1
	if currentIndex >= currentDialogueA.size():
		finishedDialogueSequence.emit()
		layer = 1
	else:
		loadDialogueBlock(currentDialogueA[currentIndex])
