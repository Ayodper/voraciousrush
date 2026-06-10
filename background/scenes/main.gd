extends Node

# game variables
const DUCK_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var score : int
var speed : float
const SCORE_MODIFIER : int = 10
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var game_running : bool

var screen_size : Vector2   # <-- FIXED (added this)

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size   # <-- FIXED (now defined)


func new_game():
	#reset variables
	score = 0
	# reset the nodes
	$duck.position = DUCK_START_POS
	$duck.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0, 0)


func _process(delta):
	if game_running:
		speed = START_SPEED

		# move dino and camera
		$duck.position.x += speed
		$Camera2D.position.x += speed
		
		#update score
		score += speed
		show_score()

		# update ground position
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true



func show_score():
		$hud.get_node("scorelabel").text = " SCORE: " + str(score/ SCORE_MODIFIER)
		
		
		
		
		
