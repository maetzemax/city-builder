extends Button

enum ActionType {
	SAVE,
	LOAD
}

@export var action_type: ActionType
@export var save_manager: SaveManager
@export var nav_manager: NavigationManager

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.current_game_state = GameManager.GameState.MAIN_MENU
	match action_type:
		0: 
			save_manager.save_game()
		1: 
			save_manager.load_game()
			nav_manager.bake_navigation_async()
