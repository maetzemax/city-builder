extends Node

class_name BuildManager

@export var camera: CameraController
@export var builder: Builder
@export var build_ui: CanvasLayer

var buildings: Dictionary = {
	0: "res://scenes/models/buildings/residential_placeholder.tscn",
	1: "res://scenes/models/buildings/saw_mill.tscn",
	2: "res://scenes/models/buildings/tree1.tscn"
}

var is_grid_enabled = false
var is_building_state: bool

func _ready():
	camera.clicked_element.connect(builder._on_camera_3d_clicked_element)
	camera.mouse_pos_on_terrain.connect(builder._on_camera_3d_mouse_pos_on_terrain)

func _process(_delta: float):
	is_building_state = GameManager.current_game_state == GameManager.GameState.BUILDING
	
	if Input.is_action_just_pressed("toggle_grid"):
		is_grid_enabled = !is_grid_enabled
