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
	var total_minutes = int(GameManager.day_progress * 24 * 60)  # Convert to total minutes in day
	@warning_ignore("integer_division")
	var hours = int(total_minutes / 60)
	var minutes = total_minutes % 60
	
	day_label.text = "Day %s %02d:%02d" % [GameManager.day_count, hours, minutes]
	day_progress.value = GameManager.day_progress * 100
	money_label.text = "%2.2f €" % EconomyManager.money
	
	var wood = _get_resources_stored(ProductionBuildingData.ResourceType.WOOD)
	var stone = _get_resources_stored(ProductionBuildingData.ResourceType.STONE)
	
	wood_label.text = "%sx Wood" % wood
	stone_label.text = "%sx Stone" % stone
	
	_get_citizens()


func _get_citizens():
	var citizens = get_tree().get_nodes_in_group("citizens")
	
	var unemployed = 0
	for citizen in citizens:
		if citizen.current_state == Citizen.CitizenState.UNEMPLOYED:
			unemployed += 1
			
	citizen_label.text = "%s Citizen (%s unemployed)" % [citizens.size(), unemployed]


func _get_resources_stored(resource: ProductionBuildingData.ResourceType) -> int:
	var buildings = get_tree().get_nodes_in_group("buildings")
	var merged = merge_building_resources(buildings)
	
	var amount = merged.get(resource, 0)
	return amount


func merge_building_resources(buildings: Array) -> Dictionary:
	var total := {}
	
	for building in buildings:
		if not "stored_resources" in building:
			continue
		
		for key in building.stored_resources.keys():
			if not total.has(key):
				total[key] = 0
			total[key] += building.stored_resources[key]
	
	return total
