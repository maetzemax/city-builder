extends Node3D

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"

@export var scene: PackedScene

var _preview_instance
var _can_place: bool

var _is_mouse_over_safe_area: bool
var _is_building_state: bool

func _process(_delta: float):
	_is_building_state = GameManager.current_game_state == GameManager.GameState.BUILDING
	canvas_layer.visible = _is_building_state
	
	var mouse_y = get_viewport().get_mouse_position().y
	var viewport_size = get_viewport().size
	var safe_area_height = viewport_size.y - viewport_size.y * 0.15
	
	_is_mouse_over_safe_area = mouse_y > safe_area_height
	
	if _preview_instance:
		_can_place = !_preview_instance.has_overlapping_areas()
		color_preview_mesh()

func color_preview_mesh():
	if _preview_instance:
		if _can_place:
			for child in _preview_instance.get_children():
				if child is MeshInstance3D:
					child.material_override = null
		else:
			var red_material = StandardMaterial3D.new()
			red_material.albedo_color = Color.RED
			for child in _preview_instance.get_children():
				if child is MeshInstance3D:
					child.material_override = red_material

func _on_camera_3d_clicked_element(pos: Vector3) -> void:
	if not _is_building_state or _is_mouse_over_safe_area:
		return

	if _can_place:
		var instance = scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = pos

func _on_camera_3d_mouse_pos_on_terrain(pos: Vector3) -> void:
	# When not building, remove preview instance
	if not _is_building_state or _is_mouse_over_safe_area:
		if _preview_instance:
			_preview_instance.queue_free()
		return
	
	if not _preview_instance:
		_preview_instance = scene.instantiate()
		get_tree().current_scene.add_child(_preview_instance)
		_preview_instance.global_position = pos
		_preview_instance.name = "Preview"
	else:
		_preview_instance.global_position = pos
