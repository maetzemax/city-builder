class_name StorageBuilding
extends Building

signal storage_changed(resource: ProductionBuildingData.ResourceType, amount: int)

var stored_resources: Dictionary = {}

var _can_store: bool = true
var detection_area: Area3D

func _ready():
	super._ready()
	add_to_group("storage_buildings")
	detection_area = BuildingDetectionArea.new()
	detection_area.radius = building_data.detection_radius
	add_child(detection_area)


func _process(_delta):
	if not is_active or GameManager.current_game_state == GameManager.GameState.PAUSED or GameManager.current_game_state == GameManager.GameState.MAIN_MENU:
		return
	
	var _stored_resources = _get_total_stored_resources(stored_resources)
	_can_store = true if not _stored_resources else building_data.storage_capacity > _stored_resources
	
	if detection_area.has_overlapping_areas() and _can_store:
		var buildings = detection_area.get_overlapping_areas()
		for building in buildings:
			if building.get_parent() is ProductionBuilding and not building.get_parent().is_preview:
				for key in building_data.accepted_resources:
					var stored = _get_total_stored_resources(building.get_parent().stored_resources)
					building.get_parent().remove_resource(key, stored)
					var remaining = stored - add_resource(key, stored)
					
					if remaining > 0:
						building.get_parent().add_resource(key, remaining)
					
				

func _get_total_stored_resources(resources: Dictionary) -> int:
	var amount = 0
	
	for key in resources.keys():
		amount += resources[0]
		
	return amount


func add_resource(resource: ProductionBuildingData.ResourceType, amount: int) -> int:
	var current = stored_resources.get(resource, 0)
	var max_can_add = building_data.storage_capacity - current
	var actual_added = min(amount, max_can_add)
	
	stored_resources[resource] = current + actual_added
	storage_changed.emit(resource, stored_resources[resource])
	return actual_added


func remove_resource(resource: ProductionBuildingData.ResourceType, amount: int) -> int:
	var current = stored_resources.get(resource, 0)
	var actual_removed = min(amount, current)
	
	stored_resources[resource] = current - actual_removed
	storage_changed.emit(resource, stored_resources[resource])
	return actual_removed

	
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"stored_resources": stored_resources,
	})
	return data


func load_from_data(data: Dictionary):
	super.load_from_data(data)
	stored_resources = data.get("stored_resources", {})
