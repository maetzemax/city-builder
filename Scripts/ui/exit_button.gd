extends Button

@export var should_navigate_to_main_menu: bool = false
@export var save_manager: SaveManager

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.current_game_state = GameManager.GameState.RUNNING
	
	if save_manager:
		save_manager.save_game()
	
	if should_navigate_to_main_menu:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	else:
		get_tree().quit()
