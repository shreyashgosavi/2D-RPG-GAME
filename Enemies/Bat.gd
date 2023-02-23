extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

@export var Acceleration = 300
@export var Max_speed = 50
@export var Friction = 200

enum{
	Idle,
	Wander,
	Chase
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = Chase

@onready var sprite = $AnimatedSprite2D
@onready var stats = $Stats
@onready var playerDectectionZone = $PlayerDetectonZone


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO , 200 * delta)
	set_velocity(knockback)
	move_and_slide()
	knockback = velocity
	
	match state:
		Idle:
			velocity = velocity.move_toward(Vector2.ZERO,Friction * delta)
			seek_player()
		
		Wander:
			pass
			
		Chase:
			var player = playerDectectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * Max_speed ,Acceleration * delta)
			else:
				state = Idle
			sprite.flip_h = velocity.x < 0

	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
		
		
	
	 

func seek_player():
	if playerDectectionZone.can_see_player():
		state = Chase

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	
func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
