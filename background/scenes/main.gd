extends Node

#load obstacles before game starts

var stump_scene = preload("res://background/scenes/stump.tscn")
var rock_scene =  preload("res://background/scenes/rock.tscn")
var chicken_scene = preload("res://background/scenes/chicken_leg.tscn")
var barrel_scene = preload("res://background/scenes/barrel.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array = []   # FIXED: initialize the array
var chicken_heights :=[200, 390]

# game variables
const DUCK_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)

var difficulty
const MAX_DIFFCULTY : int = 2

var score : int = 0
var speed : float = 0.0
const SCORE_MODIFIER : int = 10
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000
var ground_height : int
var game_running : bool = false
var last_obs = null   # FIXED: initialize so we can null-check

var screen_size : Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game()   # <-- REQUIRED


func new_game():
	# reset variables
	score = 0
	game_running = false
	show_score()
	difficulty = 0

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
		#speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
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
			
		#remove objects that have gone off the screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		# start game
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$hud/startlabel.hide()

func generate_obs():
	#generate ground obstacles
	if obstacles.is_empty() or (last_obs != null and last_obs.position.x < score + randi_range(300,500)):  # FIXED: null-check last_obs
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs +1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		#additionally random chance to spawn a chicken leg
		# FIXED: remove difficulty == 0 so it can spawn later too
		if (randi() % 2) == 0:
			#generate chicken leg obstacles
			obs = chicken_scene.instantiate()
			var obs_x : int = screen_size.x + score + 100
			var obs_y : int = chicken_heights[randi() % chicken_heights.size()]
			add_obs(obs, obs_x, obs_y)


func add_obs(obs, x, y):
	obs.position = Vector2i(x,y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)
	

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
func hit_obs(body):
	if body.name == "duck":
		game_over()


func show_score():
	$hud/scorelabel.text = "SCORE: " + str(score / SCORE_MODIFIER)



func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFCULTY:
		difficulty = MAX_DIFFCULTY


func game_over():
	get_tree().paused = true
	game_running = false
