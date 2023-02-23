extends Area2D

var player = null

func can_see_player():
	return player != null	


func _on_PlayerDetectonZone_body_entered(body:PhysicsBody2D):
	player = body

func _on_PlayerDetectonZone_body_exited(_body):
	player = null
	

