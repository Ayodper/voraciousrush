extends Node

#load obstacles before game starts

var stump_scene = preload("res://background/scenes/stump.tscn")
var rock_scene =  preload("res://background/scenes/rock.tscn")
var chicken_scene = preload("res://background/scenes/chicken_leg.tscn")
var barrel_scene = preload("res://background/scenes/barrel.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array
var chicken_heights :=[200, 390]





# game variables
const DUCK_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var score : int = 0
var speed : float = 0.0
const SCORE_MODIFIER : int = 10
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var game_running : bool = false
var last_obs

var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	new_game()   # <-- REQUIRED


func new_game():
	# reset variables
	score = 0
	game_running = false
	show_score()

	# reset nodes
	$duck.position = DUCK_START_POS
	$duck.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$ground.position = Vector2i(0, 0)

	# reset HUD
	$hud/startlabel.show()
	$hud/scorelabel.show()


func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		
		#generate obstacles
		generate_obs()
		
		
		
		
		
		
		
		
		
		
		


		# move duck + camera
		$duck.position.x += speed
		$Camera2D.position.x += speed

		# update score
		score += speed
		show_score()

		# loop ground
		if $Camera2D.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x

	else:
		# start game
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$hud/startlabel.hide()

func generate_obs():
	#generate ground obstacles
	if obstacles.is_empty():
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		obs = obs_type.instantiate()
		last_obs = obs
		add_child(obs)
		obstacles.append(obs)

func show_score():
	$hud/scorelabel.text = "SCORE: " + str(score / SCORE_MODIFIER)
