extends Node


#game variables
const DUCK_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func new_game():
	#reset the nodes
	$duck.position = DUCK_START_POS
	$duck.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	
	
	#move dino and camera
	$duck.position.x += speed
	$Camera2D.position.x += speed
