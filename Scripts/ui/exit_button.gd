extends Button

@export var should_navigate_to_main_menu: bool = false

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	if should_navigate_to_main_menu:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		get_tree().quit()
