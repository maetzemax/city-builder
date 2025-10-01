class_name ResidentialBuilding
extends Building

var occupants: Array[Citizen]

var citizen_spawn_time = 10
var _current_time = 0


func _ready():
	super._ready()
	add_to_group("residential_buildings")


func _process(_delta):
	if not is_active or GameManager.current_game_state == GameManager.GameState.PAUSED or GameManager.current_game_state == GameManager.GameState.MAIN_MENU:
		return
		
	if occupants.size() >= building_data.max_occupants:
		return
	
	_current_time += _delta
	
	if _current_time >= citizen_spawn_time:
		_current_time = 0.0
		
		var citizen = spawn_npc()
		add_assigned_citizen(citizen)
		add_current_citizen(citizen)
		
		print("Citizen Spawned")


func add_assigned_citizen(citizen: Citizen):
	if not occupants.has(citizen):
		occupants.append(citizen)
	
	citizen._home_building = self


func add_current_citizen(citizen: Citizen):
	if not occupants.has(citizen):
		occupants.append(citizen)

	citizen._home_building = self


func remove_current_citizen(citizen: Citizen):
	occupants.erase(citizen)
	citizen.global_position = npc_spawn_point.global_position


#region Encoding / Decoding
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"citizen_spawn_time": citizen_spawn_time,
		"_current_time": _current_time
	})
	return data


func load_from_data(data: Dictionary):
	super.load_from_data(data)
	citizen_spawn_time = data.get("citizen_spawn_time", 30.0)
	_current_time = data.get("_current_time", 0.0)
#endregion
