extends Button

enum ActionType {
	SAVE,
	LOAD
}

@export var action_type: ActionType
@export var save_manager: SaveManager

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.current_game_state = GameManager.GameState.RUNNING
	match action_type:
		0: save_manager.save_game()
		1: save_manager.load_game()
