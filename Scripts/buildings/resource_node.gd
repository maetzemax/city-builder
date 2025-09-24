extends Building

class_name ResourceNode

var current_amount: int
var respawn_timer: float = 0.0
var is_depleted: bool = false

signal resource_depleted
signal resource_respawned

func _ready():
	super._ready()
	current_amount = building_data.max_amount
	add_to_group("resource_nodes")

func _process(delta):
	if is_depleted and building_data.respawn_enabled:
		respawn_timer += delta
		if respawn_timer >= building_data.respawn_time:
			respawn_resource()

func extract_resource(amount: float) -> float:
	if is_depleted:
		return 0.0
	
	var extracted = min(amount, current_amount)
	current_amount -= extracted
	
	if current_amount <= 0:
		deplete_resource()
	
	return extracted

func deplete_resource():
	is_depleted = true
	current_amount = 0
	respawn_timer = 0.0
	visible = false
	resource_depleted.emit()

func respawn_resource():
	is_depleted = false
	current_amount = building_data.max_amount
	visible = true
	resource_respawned.emit()

func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"current_amount": current_amount,
		"respawn_timer": respawn_timer,
		"is_depleted": is_depleted
	})
	return data

func load_from_data(data: Dictionary):
	super.load_from_data(data)
	current_amount = data.get("current_amount")
	respawn_timer = data.get("respawn_timer", 0.0)
	is_depleted = data.get("is_depleted", false)
