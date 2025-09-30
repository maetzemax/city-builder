extends MarginContainer

@export_group("Day")
@export var day_label: Label
@export var day_progress: ProgressBar

@export_group("Resourcers")
@export var resources: Array[ProductionBuildingData.ResourceType]
@export var wood_label: Label
@export var stone_label: Label

@export_group("Economic")
@export var money_label: Label

@export_group("Citizen")
@export var citizen_label: Label

func _process(_delta):
	day_label.text = "Day %o" % GameManager.day_count
	day_progress.value = GameManager.day_progress * 100
	money_label.text = "%2.2f €" % EconomyManager.money
	_get_resources_stored_in_production_output()
	_get_citizens()
	
func _get_citizens():
	var residentials = get_tree().get_nodes_in_group("residental_buildings")
	
	var occupants = 0
	for residential in residentials:
		occupants += residential.occupants.size()
			
	citizen_label.text = "%o Citizen" % [occupants]

func _get_resources_stored_in_production_output():
	var buildings = get_tree().get_nodes_in_group("resource_buildings")
	var merged = merge_building_resources(buildings)
	
	for resource in resources:
		var amount = merged.get(resource)
		
		if not amount:
			return
			
		match resource:
			ProductionBuildingData.ResourceType.WOOD:
				wood_label.text = "%dx Wood" % amount
				
			ProductionBuildingData.ResourceType.STONE:
				stone_label.text = "%dx Stone" % amount

func merge_building_resources(buildings: Array) -> Dictionary:
	var total := {}
	
	for building in buildings:
		for key in building.stored_resources.keys():
			if not total.has(key):
				total[key] = 0
			total[key] += building.stored_resources[key]
	
	return total
