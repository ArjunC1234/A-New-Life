extends CanvasLayer

@onready var coinLabel = $HBoxContainer/coinLabel
@onready var fadeOut = $CharmModal/fadeOut
@onready var modal = $CharmModal
@onready var Description = $CharmModal/centerContainer/Container/Description
@onready var Name = $CharmModal/centerContainer/Container/Name
@onready var CharmImage = $CharmModal/centerContainer/Container/charmImageRect
@onready var TimeOutBar = $CharmModal/TimeoutBar
@onready var hearts = [$Hearts/h1, $Hearts/h2, $Hearts/h3, $Hearts/h4, $Hearts/h5]
@onready var charmButtons = $Charms
@onready var HUDCharmDelay = $HUDCharmDelay

var fullHeart = preload("res://assets2/other/rock_heart/heart_0.png")
var halfHeart = preload("res://assets2/other/rock_heart/heart_1.png")
var emptyHeart = preload("res://assets2/other/rock_heart/heart_2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	coinLabel.text = "x "+ str(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not fadeOut.is_stopped():
		TimeOutBar.value = (fadeOut.time_left/fadeOut.wait_time) * TimeOutBar.max_value
		if Input.is_action_just_pressed("exit"):
			TimeOutBar.value = 0
			fadeOut.stop()
			modal.fadeOut()
	



func _on_character_body_2d_coin_change(coins):
	coinLabel.text = "x "+ str(coins)


func _on_character_body_2d_update_health(playerHP):
	for i in range(1, hearts.size()+1, 1):
		var heart = hearts[i-1]
		var texture

		# Check if the current index is within the player's HP range
		if i * 2 <= playerHP:
			texture = fullHeart
		elif i * 2 - 1 == playerHP:
			texture = halfHeart
		else:
			texture = emptyHeart

		# Set the texture of the current heart image node
		heart.texture = texture


func _on_character_body_2d_add_charms_to_hud(c):
	if HUDCharmDelay == null:
		await get_tree().create_timer(0.1).timeout
	else:
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
	print("heiii")
	openCharmModal(d)


func _on_charm_button_2_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_3_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_4_send_charm_dict(d):
	openCharmModal(d)


func _on_charm_button_5_send_charm_dict(d):
	openCharmModal(d)
