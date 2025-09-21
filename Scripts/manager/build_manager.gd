extends Node

class_name BuildManager

@export var camera: CameraController
@export var builder: Builder

@onready var build_ui: CanvasLayer = $BuildUI

var is_building_state: bool
var is_mouse_over_safe_area: bool

func update_selected_placeable(placeable: Placeable):
	builder.placeable = placeable

func _ready():
	camera.clicked_element.connect(builder._on_camera_3d_clicked_element)
	camera.mouse_pos_on_terrain.connect(builder._on_camera_3d_mouse_pos_on_terrain)

func _process(_delta: float):
	is_building_state = GameManager.current_game_state == GameManager.GameState.BUILDING
	build_ui.visible = is_building_state

	var mouse_y = get_viewport().get_mouse_position().y
	var viewport_size = get_viewport().size
	var safe_area_height = viewport_size.y - viewport_size.y * 0.15
	
	is_mouse_over_safe_area = mouse_y > safe_area_height
