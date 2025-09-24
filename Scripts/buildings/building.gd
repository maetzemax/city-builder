extends Node3D

class_name Building

@export var building_data: BuildingData

var is_active: bool = true

func _ready():
	add_to_group("buildings")
