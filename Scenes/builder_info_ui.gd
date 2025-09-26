extends Control

func _process(_delta):
	if Input.is_action_just_pressed("toggle_builder_help"):
		visible = !visible
