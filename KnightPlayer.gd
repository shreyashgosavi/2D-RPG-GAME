extends CharacterBody2D


@export var Acceleration: int = 25
@export var Max_speed: int = 50
@export var Friction: int = 80
@export var walk_speed: int = 50
@export var run_speed: int = 80

@onready var animation = $AnimatedSprite2D
@onready var camera = $Camera2D
@export var motion = Vector2()
var is_running = null


func _physics_process(delta):
	var input = Vector2()
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input = input.normalized()
	
	
	if Input.is_action_just_pressed("run"):
		is_running = true
	if Input.is_action_just_released("run"):
		is_running = false
		
	if input != Vector2.ZERO:
		
		if input.x > 0:
			if is_running == true:
				animation.play("Run")
			else:
				animation.play("Walk")
			animation.flip_h = false
		else:
			if is_running == true:
				animation.play("Run")
			else:
				animation.play("Walk")
			animation.flip_h = true
		
		if is_running == true:
			Max_speed = run_speed
		else:
			Max_speed = walk_speed
		
		motion += input * Acceleration * delta
		motion = motion.limit_length(Max_speed * delta)
	else:
		animation.play("Idle")
		motion = motion.move_toward(Vector2.ZERO , Friction * delta)
		
	move_and_collide(motion)
	
