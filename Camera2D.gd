extends Camera2D

@export var DefualtTargetNodepath: NodePath
var player
@export var target_new_node: NodePath
var target_node 
@export var lerpspeed = 0.05
var targetZoom = 0
var zoomSpeed = 0
var currentZoom = zoom

func setNodeToFollow(importNodePath: NodePath):
	target_node = get_node(importNodePath)
	print(importNodePath)
	
'''
func change_lerpspeed(newSpeed):
	lerpspeed = newSpeed
		
func change_zoom(newZoom: float, speed: float):
	newZoom = targetZoom
	speed = zoomSpeed
	
'''

#Called when the node enters the scene tree for the first time.
func _ready():
	target_node = get_node(target_new_node)
	player = get_node(DefualtTargetNodepath)


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_node == null:
		self.position = lerp(self.position, player.position, lerpspeed)
	else:
		#position = player.position + (target_node.position * 3)
		self.position = lerp(self.position, (target_node.position), lerpspeed)
'''

	zoomIn(delta)
	
func zoomIn(deltaValue: float):
	zoom.x = lerp(zoom.x, targetZoom, zoomSpeed * deltaValue)
	zoom.y = lerp(zoom.y, targetZoom, zoomSpeed * deltaValue)
		#print(target_node.position + player.position)
		#print(player.position)
'''
