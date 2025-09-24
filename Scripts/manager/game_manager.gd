extends Node

class_name GameManager

@export var save_manager: SaveManager

enum GameState {
	RUNNING,
	BUILDING,
	PAUSED
}

static var current_game_state = GameState.RUNNING

static var is_day: bool = true

func _ready():
	if GameData.should_load_save_file:
		save_manager.load_game()

func _process(_delta: float):
	if Input.is_action_just_pressed("save_game"):
		save_manager.save_game()
	
	if Input.is_action_just_pressed("load_game"):
		save_manager.load_game()

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.keycode == KEY_B and event.is_pressed():
			if current_game_state == GameState.RUNNING:
				current_game_state = GameState.BUILDING
			else:
				current_game_state = GameState.RUNNING
		
		if event.keycode == KEY_PLUS and event.is_pressed():
			EconomyManager.add_money(10)
			
		if event.keycode == KEY_MINUS and event.is_pressed():
			EconomyManager.reduce_money(10)
