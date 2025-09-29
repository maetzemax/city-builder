extends Node

class_name BuildManager

@export var camera: CameraController
@export var navigation_manager: NavigationManager

var buildings: Dictionary = {
	0: "uid://bn2j568mwjyxb", # residential placeholder
	1: "uid://cdw4atnef81ew", # lumber hut
	2: "uid://bmglwbl6r4ao7" # tree1
}

var is_grid_enabled = false
var is_building_state: bool

func _process(_delta: float):
	is_building_state = GameManager.current_game_state == GameManager.GameState.BUILDING
	
	if Input.is_action_just_pressed("toggle_grid"):
		is_grid_enabled = !is_grid_enabled
