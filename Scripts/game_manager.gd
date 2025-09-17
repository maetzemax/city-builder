extends Node

enum GameState {
	RUNNING,
	BUILDING,
	PAUSED
}

var current_game_state = GameState.RUNNING

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == KEY_B and event.is_pressed():
			if current_game_state == GameState.RUNNING:
				current_game_state = GameState.BUILDING
			else:
				current_game_state = GameState.RUNNING
