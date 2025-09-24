extends Building

class_name ProductionBuilding

var stored_resources: Dictionary<ProductionBuildingData.ResourceType, int>

# Count the ticks which passed.
var production_timer: int = 0
var is_producing: bool = false

signal production_completed(output: Dictionary)
signal storage_changed(resource: String, amount: int)

func _ready():
	super._ready()
	add_to_group("production_buildings")

func _process(delta):
	if not is_active:
		return
		
	if can_produce() and not is_producing:
		start_production()
	
	if is_producing:
		production_timer += delta
		if production_timer >= production_time:
			complete_production()

func can_produce() -> bool:
	# Prüfe Input-Ressourcen
	for resource in input_resources:
		var required = input_resources[resource]
		var available = stored_resources.get(resource, 0)
		if available < required:
			return false
	
	# Prüfe Output-Platz
	for resource in output_resources:
		var output_amount = output_resources[resource]
		var current_amount = stored_resources.get(resource, 0)
		if current_amount + output_amount > storage_capacity:
			return false
	
	return true

func start_production():
	# Verbrauche Input-Ressourcen
	for resource in input_resources:
		var required = input_resources[resource]
		remove_resource(resource, required)
	
	is_producing = true
	production_timer = 0.0

func complete_production():
	# Füge Output-Ressourcen hinzu
	for resource in output_resources:
		var amount = output_resources[resource]
		add_resource(resource, amount)
	
	is_producing = false
	production_completed.emit(output_resources)

func add_resource(resource: String, amount: int) -> int:
	var current = stored_resources.get(resource, 0)
	var max_can_add = storage_capacity - current
	var actual_added = min(amount, max_can_add)
	
	stored_resources[resource] = current + actual_added
	storage_changed.emit(resource, stored_resources[resource])
	return actual_added

func remove_resource(resource: String, amount: int) -> int:
	var current = stored_resources.get(resource, 0)
	var actual_removed = min(amount, current)
	
	stored_resources[resource] = current - actual_removed
	storage_changed.emit(resource, stored_resources[resource])
	return actual_removed

func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"stored_resources": stored_resources,
		"production_timer": production_timer,
		"is_producing": is_producing
	})
	return data

func load_from_data(data: Dictionary):
	super.load_from_data(data)
	stored_resources = data.get("stored_resources", {})
	production_timer = data.get("production_timer", 0.0)
	is_producing = data.get("is_producing", false)
