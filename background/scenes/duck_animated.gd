extends CharacterBody2D


const GRAVITY = 4200
const JUMP_SPEED = -1800

func _physics_process(delta):
	velocity.y+= GRAVITY * delta
	if Input.is_action_pressed("ui_accept"):
		velocity.y=JUMP_SPEED
		
		
	move_and_slide()
