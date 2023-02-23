extends Node2D

signal level_changed(level_name)
var entered = true
@export var level_name: String = "Level6"

func _process(_delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			emit_signal("level_changed",level_name)
			
func _on_Area6_body_entered(body):
	entered = true

func _on_Area6_body_exited(body):
	entered = false
