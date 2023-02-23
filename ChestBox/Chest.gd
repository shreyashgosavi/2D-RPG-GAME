extends StaticBody2D

var in_zone = false

func _ready():
	$opened.visible = false
	$close.visible = true
	
	
func chest_opened():
	$opened.visible = true
	$close.visible = false
	

func _process(delta):
	if Input.is_action_just_pressed("BoxOpenAndClose"):
		chest_opened()
		

func _on_chest_Zone_body_entered(body):
	in_zone = true

func _on_chest_Zone_body_exited(_body):
	in_zone = false
