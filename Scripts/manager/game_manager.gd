extends Node

class_name GameManager

@export var save_manager: SaveManager

@export var pause_ui: CanvasLayer
@export var build_ui: CanvasLayer
@export var hud: CanvasLayer

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
	if Input.is_action_just_pressed("ui_cancel"):
		match current_game_state:
			GameState.RUNNING:
				current_game_state = GameState.PAUSED
			GameState.BUILDING:
				current_game_state = GameState.PAUSED
			GameState.PAUSED:
				current_game_state = GameState.RUNNING
	
	match current_game_state:
		GameState.RUNNING:
			hud.visible = true
			build_ui.visible = false
			pause_ui.visible = false
		GameState.BUILDING:
			hud.visible = true
			build_ui.visible = true
			pause_ui.visible = false
		GameState.PAUSED:
			hud.visible = false
			build_ui.visible = false
			pause_ui.visible = true

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
