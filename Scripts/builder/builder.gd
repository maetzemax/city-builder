extends Node3D

class_name Builder

@export var build_manager: BuildManager
@export var environment: Node3D
@export var preview: Node3D

var placeable: Placeable

var _preview_instance
var _can_place: bool
var _rotation: float

func _process(_delta: float):
	if _preview_instance:
		_can_place = not _preview_instance.has_overlapping_areas()
		_preview_instance.global_rotation.y = _rotation
		
	if placeable and EconomyManager.money < placeable.cost:
		_can_place = false
		
	_color_preview_mesh()
	_check_preview()
	
func _input(event):
	if _preview_instance:
		if event is InputEventMouse and event.ctrl_pressed and event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_WHEEL_UP:
					_rotation += deg_to_rad(5)
				
				MOUSE_BUTTON_WHEEL_DOWN:
					_rotation -= deg_to_rad(5)
		
		if Input.is_action_just_pressed("rotate_building"):
			_rotation += deg_to_rad(90)

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
	if _can_place and _preview_instance and placeable:
		var instance = placeable.scene.instantiate()
		environment.add_child(instance)
		instance.global_position = pos
		instance.rotate_y(_rotation)
		EconomyManager.reduce_money(placeable.cost)

func _on_camera_3d_mouse_pos_on_terrain(pos: Vector3) -> void:
	if placeable and not _preview_instance:
		_preview_instance = placeable.scene.instantiate()
		preview.add_child(_preview_instance)
		_preview_instance.global_position = pos
		_preview_instance.name = "Preview"
	elif _preview_instance:
		_preview_instance.global_position = pos
