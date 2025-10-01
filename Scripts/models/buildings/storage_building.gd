class_name StorageBuilding
extends Building

signal storage_changed(resource: ProductionBuildingData.ResourceType, amount: int)

var stored_resources: Dictionary = {}


func _ready():
	super._ready()
	add_to_group("storage_buildings")


func _process(_delta):
	pass

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
	stored_resources = data.get("stored_resources", {})
