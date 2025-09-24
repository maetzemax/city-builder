extends Node3D

class_name Builder

@export var build_manager: BuildManager
@export var environment: Node3D
@export var preview: Node3D

var selected_building: BuildingData

var _preview_instance
var _can_place: bool
var _rotation: float

func _process(_delta: float):
	if _preview_instance:
		_can_place = not _preview_instance.has_overlapping_areas()
		_preview_instance.global_rotation.y = _rotation
		
	if selected_building and EconomyManager.money < selected_building.construction_cost:
		_can_place = false
		
	# Rotation
	if Input.is_action_just_pressed("rotate_precise_right"):
		_rotation += deg_to_rad(5)
	elif Input.is_action_just_pressed("rotate_precise_left"):
		_rotation -= deg_to_rad(5)
	elif Input.is_action_just_pressed("rotate_building"):
		_rotation += deg_to_rad(90)
	elif Input.is_action_pressed("rotate_precise_right"):
		_rotation += deg_to_rad(5)
	elif Input.is_action_pressed("rotate_precise_left"):
		_rotation -= deg_to_rad(5)
		
	_color_preview_mesh()
	_check_preview()

func _color_preview_mesh():
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
					
func _check_preview():
	if (not build_manager.is_building_state or build_manager.is_mouse_over_safe_area) and _preview_instance:
		_preview_instance.queue_free()
		return

func _on_camera_3d_clicked_element(pos: Vector3) -> void:
	if _can_place and _preview_instance and selected_building:
		var scene = load(build_manager.buildings[selected_building.building_id])
		var instance = scene.instantiate()
		environment.add_child(instance)
		instance.global_position = snap_to_grid(pos)
		instance.rotate_y(_rotation)
		EconomyManager.reduce_money(selected_building.construction_cost)

func _on_camera_3d_mouse_pos_on_terrain(pos: Vector3) -> void:
	if selected_building and not _preview_instance:
		var scene = load(build_manager.buildings[selected_building.building_id])
		_preview_instance = scene.instantiate()
		preview.add_child(_preview_instance)
		_preview_instance.global_position = snap_to_grid(pos)
		_preview_instance.name = "Preview"
	elif _preview_instance:
		_preview_instance.global_position = snap_to_grid(pos)

func snap_to_grid(pos: Vector3) -> Vector3:
	if not build_manager.is_grid_enabled:
		return pos
	
	return Vector3(round(pos.x), pos.y, round(pos.z))
