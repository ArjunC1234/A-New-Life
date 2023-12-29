extends CanvasLayer

@onready var coinLabel = $coinLabel
@onready var fadeOut = $CharmModal/fadeOut
@onready var modal = $CharmModal
@onready var Description = $CharmModal/centerContainer/Container/Description
@onready var Name = $CharmModal/centerContainer/Container/Name
@onready var CharmImage = $CharmModal/centerContainer/Container/charmImageRect
@onready var TimeOutBar = $CharmModal/TimeoutBar
@onready var hearts = [$Hearts/h1, $Hearts/h2, $Hearts/h3, $Hearts/h4, $Hearts/h5]
@onready var charmButtons = $Charms

var fullHeart = preload("res://assets2/other/rock_heart/heart_0.png")
var halfHeart = preload("res://assets2/other/rock_heart/heart_1.png")
var emptyHeart = preload("res://assets2/other/rock_heart/heart_2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	coinLabel.text = str(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not fadeOut.is_stopped():
		TimeOutBar.value = (fadeOut.time_left/fadeOut.wait_time) * TimeOutBar.max_value
		if Input.is_action_just_pressed("exit"):
			TimeOutBar.value = 0
			fadeOut.stop()
			modal.fadeOut()
	



func _on_character_body_2d_coin_change(coins):
	coinLabel.text = str(coins)


func _on_character_body_2d_update_health(h):
	var a_hearts = h/2
	for heart in hearts:
		a_hearts -= 1
		if a_hearts >= 0:
			heart.texture = fullHeart
		elif a_hearts == -0.5:
			heart.texture = halfHeart
		elif a_hearts < -0.5:
			heart.texture = emptyHeart


func _on_character_body_2d_add_charms_to_hud(c):
	openCharmModal(c)
	for charmButton in charmButtons.get_children():
		if charmButton.disabled:
			charmButton.charmDict = c
			break
	


func _on_fade_out_timeout():
	modal.fadeOut()

func openCharmModal(charmDict):
	Name.text = charmDict.name
	Description.text = charmDict.description
	CharmImage.modulate = charmDict.color
	TimeOutBar.value = 100
	modal.fadeIn()
	fadeOut.start()

func _on_charm_button_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_2_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_3_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_4_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_5_send_charm_dict(d):
	openCharmModal(d)
