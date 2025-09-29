class_name ResidentialBuilding
extends Building

var current_occupants: int = 0
var occupants: Array[CitizenData]

var citizen_spawn_time = 30
var _current_time = 0


func _ready():
	super._ready()
	add_to_group("residental_buildings")


func _process(_delta):
	if not is_active or GameManager.current_game_state == GameManager.GameState.PAUSED or GameManager.current_game_state == GameManager.GameState.MAIN_MENU:
		return
		
	_current_time += _delta
	
	if _current_time > citizen_spawn_time and current_occupants < building_data.max_occupants:
		_current_time = 0.0
		
		spawn_npc()
		add_occupants(1)
		
		print("Citizen Spawned")


func add_occupants(amount: int):
	if current_occupants >= building_data.max_occupants:
		return
	
	if current_occupants + amount > building_data.max_occupants:
		return
		
	current_occupants += amount


func remove_occupants(amount: int):
	var new_amount = current_occupants - amount
	current_occupants = max(new_amount, 0)


#region Encoding / Decoding
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"current_occupants": current_occupants,
	})
	return data


func load_from_data(data: Dictionary):
	super.load_from_data(data)
	current_occupants = data.get("current_occupants", 0)
#endregion
