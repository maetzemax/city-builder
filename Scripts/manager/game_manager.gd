class_name GameManager
extends Node

@export var save_manager: SaveManager
@export var cycle_controller: CycleController

@export var pause_ui: CanvasLayer
@export var build_ui: CanvasLayer
@export var hud: CanvasLayer

enum GameState {
	RUNNING,
	BUILDING,
	PAUSED,
	MAIN_MENU,
}

static var current_game_state = GameState.MAIN_MENU

static var is_day: bool = true

static var day_count: int
static var day_progress: float


func _ready():
	current_game_state = GameState.RUNNING
	cycle_controller.day_started.connect(_on_day_started)
	cycle_controller.night_started.connect(_on_night_started)


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
	
	day_progress = cycle_controller.get_cycle_progress()


func _on_day_started():
	is_day = true
	day_count += 1
	_pay_upkeep()


func _on_night_started():
	is_day = false
	

func _pay_upkeep():
	var buildings = get_tree().get_nodes_in_group("buildings")
	var upkeep = 0.0
	
	for building in buildings:
		upkeep += building.building_data.upkeep_cost

	EconomyManager.reduce_money(upkeep)


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
