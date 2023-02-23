extends Node

var next_level: String

@onready var current_level = $Level1
@onready var anim = $AnimationPlayer


func _ready() -> void:
	print("ready")
	current_level.connect("level_changed",Callable(self,"handle_level_changed"))
	
	
func handle_level_changed(current_level_name: String):
	var next_level_name: String
	print(current_level_name + "current level")
	match current_level_name:
		"Level1":
			next_level_name = "Level2"
		"Level2":
			next_level_name = "Level3"
		"Level3":
			next_level_name = "Level4"
		"Level4":
			next_level_name = "Level5"
		"Level5":
			next_level_name = "Level6"
		"Level6":
			next_level_name = "Level7"
		"Level7":
			next_level_name = "Level8"
		"Level8":
			next_level_name = "Level9"
		"Level9":
			next_level_name = "Level10"
		_:
			return
	next_level = load("res://Stages/" + next_level_name + ".tscn").instantiate()
	next_level.z_index = -1
	add_child(next_level)
	print("fade")
	anim.play("fade_in")
	next_level.connect("level_changed",Callable(self,"handle_level_changed"))
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_in":
			current_level.queue_free()
			current_level = next_level
			current_level.z_index = 0
			next_level = null
			anim.play("fade_out")
