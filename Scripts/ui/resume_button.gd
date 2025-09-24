extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	GameManager.current_game_state = GameManager.GameState.RUNNING
