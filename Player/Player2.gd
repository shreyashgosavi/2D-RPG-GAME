extends CharacterBody2D


@export var Acceleration: int = 500
@export var Max_Speed: int = 100
@export var Jump_Speed: int = 125
@export var Friction: int = 500

enum{
	Move,
	Jump,
	JumpLand,
	Attack
}

var state =Move
var motion = Vector2.ZERO
var jump_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitBox

func _ready():
	stats.connect("no_health",Callable(self,"queue_free"))
	animationTree.active = true
	swordHitbox.knockback_vector = jump_vector
	

func _physics_process(delta):
	match state:
		Move:
			move_state(delta)
		Jump:
			jump_state(delta)
		JumpLand:
			jumpland_state(delta)
		Attack:
			attack_state(delta)
	
	
func move_state(delta):
	var input_vector =Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		jump_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Jump/blend_position", input_vector)
		animationTree.set("parameters/JumpLand/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * Max_Speed , Acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO , Friction * delta)
	
	move()
	
	if Input.is_action_just_pressed("Jump"):
		state = Jump

	if Input.is_action_just_pressed("Attack"):
		state = Attack


func jump_state(_delta):
	velocity = jump_vector * Jump_Speed
	animationState.travel("Jump")
	
func jumpland_state(delta):
	velocity = jump_vector * Jump_Speed * Friction
	animationState.travel("JumpLand")
	move()

func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
	
func jumpland_animation_finished():
	velocity = velocity * 0.10
	state = Move
	
func attack_animation_finished():
	state = Move
	
func _on_HurtBox_area_entered(area):
	stats.health -= 1
