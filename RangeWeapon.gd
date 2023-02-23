extends Node2D

@onready var sprite =get_node("Sprite2D")

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var angle = direction.angle()
	rotation = angle
	
	if sprite.rotation > 180 && sprite.rotation < 360 :
		sprite.flip_h = true
	
	
	
	






