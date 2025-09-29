class_name ResourceBuilding
extends ProductionBuilding

var workers: Array[Citizen]
var connected_resource_nodes: Array[ResourceNode] = []

var working_area: BuildingWorkingArea

func _ready():
	super._ready()
	add_to_group("resource_buildings")
	working_area = BuildingWorkingArea.new()
	working_area.radius = building_data.detection_radius
	add_child(working_area)


func _process(delta):
	if GameManager.current_game_state == GameManager.GameState.PAUSED or GameManager.current_game_state == GameManager.GameState.MAIN_MENU:
		return
		
	super._process(delta)
	call_deferred("find_nearby_resources")


func find_nearby_resources():
	connected_resource_nodes.clear()
	
	for node in working_area.get_overlapping_areas():
		var parent = node.get_parent()
		if parent.building_data.resource_type == building_data.resource_type and parent.is_in_group("resource_nodes") and not parent.is_preview:
			connected_resource_nodes.append(parent)


func can_produce() -> bool:
	connected_resource_nodes = connected_resource_nodes.filter(func(node): return node != null and node.current_amount > 0)
	
	if connected_resource_nodes.is_empty():
		return false
	
	var current_amount = stored_resources.get(building_data.resource_type, 0)
	return current_amount < building_data.storage_capacity


func start_production():
	if connected_resource_nodes.is_empty():
		return
	
	var node = connected_resource_nodes[randi() % connected_resource_nodes.size()]
	
	var extracted = node.extract_resource(building_data.extraction_rate)
	
	if extracted > 0:
		add_resource(building_data.resource_type, int(extracted))
		is_producing = true
		production_timer = 0.0


func complete_production():
	is_producing = false
	production_completed.emit({building_data.resource_type: building_data.extraction_rate})
