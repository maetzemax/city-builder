extends Node3D

class_name Building

@export var building_data: BuildingData

var is_preview: bool = false
var is_active: bool = true

func _ready():
	if not is_preview:
		add_to_group("buildings")

func get_save_data() -> Dictionary:
	return {
		"building_id": building_data.building_id,
		"position": global_position,
		"rotation_y": global_rotation.y,
		"is_active": is_active
	}

func load_from_data(data: Dictionary):
	global_position = data.get("position", Vector3.ZERO)
	global_rotation.y = data.get("rotation_y", 0.0)
	is_active = data.get("is_active", true)
