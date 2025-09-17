extends Node3D

@export var scene: PackedScene

var _preview_instance
var _can_place: bool = true

func _process(_delta: float):
	_can_place = !_preview_instance.has_overlapping_areas()
	color_preview_mesh()

func color_preview_mesh():
	if _preview_instance:
		var mesh_instance = _preview_instance.get_node("MeshInstance3D")
		
		if _can_place:
			mesh_instance.material_override = null
		else:
			var red_material = StandardMaterial3D.new()
			red_material.albedo_color = Color.RED
			mesh_instance.material_override = red_material

func _on_camera_3d_clicked_element(pos: Vector3) -> void:
	if _can_place:
		var instance = scene.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = pos

func _on_camera_3d_mouse_pos_on_terrain(pos: Vector3) -> void:
	if not _preview_instance:
		_preview_instance = scene.instantiate()
		get_tree().current_scene.add_child(_preview_instance)
		_preview_instance.global_position = pos
		_preview_instance.name = "Preview"
	else:
		_preview_instance.global_position = pos
