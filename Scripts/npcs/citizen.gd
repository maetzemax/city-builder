class_name Citizen
extends NPCController

signal arrived_at_home
signal arrived_at_work

enum CitizenState {
	UNEMPLOYED,
	WORKING,
	RESTING,
	TRAVELING_TO_WORK,
	TRAVELING_TO_HOME,
}

@export var full_name: String = "Hans Joachim Peter"
@export var age: int = 18

@export var current_state: CitizenState = CitizenState.UNEMPLOYED

# Cached building references for performance
var _workplace_building: ProductionBuilding
var _home_building: Building


func _ready():
	super._ready()
	add_to_group("citizens")


func _process(_delta):
	if not _home_building:
		update_home_place()
		
	if not _workplace_building:
		update_working_place()
	
	if _workplace_building and current_state == CitizenState.UNEMPLOYED:
		walk_to_work()
	
	match current_state:
		CitizenState.RESTING, CitizenState.UNEMPLOYED:
			visible = false
		_:
			visible = true
	
	if current_state == CitizenState.TRAVELING_TO_WORK and nav_agent.target_position == _workplace_building.npc_spawn_point.global_position and nav_agent.distance_to_target() < 2:
		arrived_at_work.emit()
		current_state = CitizenState.WORKING
		
	if current_state == CitizenState.TRAVELING_TO_HOME and nav_agent.target_position == _home_building.npc_spawn_point.global_position and nav_agent.distance_to_target() < 2:
		arrived_at_home.emit()
		current_state = CitizenState.RESTING


func _physics_process(_delta):
	match current_state:
		CitizenState.UNEMPLOYED, CitizenState.RESTING:
			if not _home_building:
				return
			
			global_position = _home_building.global_position
			visible = false
			return
		CitizenState.WORKING:
			global_position = _workplace_building.global_position
			visible = false
			return
		_:
			super._physics_process(_delta)
			visible = true


func update_working_place():
	var buildings = get_tree().get_nodes_in_group("production_buildings")
	
	var shortest_distance: float
	var temp_building: Building = null
	
	for building in buildings:
		if building.is_preview or building.workers_count == building.building_data.max_workers:
			return
			
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
			
	_workplace_building = temp_building
	_workplace_building.add_new_worker(self)


func update_home_place():
	var buildings = get_tree().get_nodes_in_group("residental_buildings")
	
	var shortest_distance: float
	var temp_building: Building = null
	
	for building in buildings:
		if building.is_preview:
			return
		
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
	
	_home_building = temp_building


func walk_to_work():
	set_target_position(_workplace_building.npc_spawn_point.global_position)
	current_state = CitizenState.TRAVELING_TO_WORK


func walk_home():
	set_target_position(_home_building.npc_spawn_point.global_position)
	current_state = CitizenState.TRAVELING_TO_HOME

#region Save/Load System
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"full_name": full_name,
		"age": age,
		"current_state": current_state,
		"workplace_position": _workplace_building.global_position if _workplace_building else Vector3.ZERO,
		"home_position": _home_building.global_position if _home_building else Vector3.ZERO,
	})
	return data

func load_from_data(data: Dictionary):
	super.load_from_data(data)
	full_name = data.get("full_name", "Hans Joachim Peter")
	age = data.get("age", 18)
	current_state = data.get("current_state", CitizenState.UNEMPLOYED)
	
	# Gebäude anhand ihrer Position in der bereits geladenen Szene finden
	var workplace_pos = data.get("workplace_position", Vector3.ZERO)
	var home_pos = data.get("home_position", Vector3.ZERO)
	
	if workplace_pos != Vector3.ZERO:
		_workplace_building = find_building_at_position(workplace_pos, "production_buildings")
		_workplace_building.add_worker(self)
	
	if home_pos != Vector3.ZERO:
		_home_building = find_building_at_position(home_pos, "residental_buildings")

func find_building_at_position(target_pos: Vector3, group_name: String) -> Building:
	var buildings = get_tree().get_nodes_in_group(group_name)
	
	for building in buildings:
		if building.global_position.distance_to(target_pos) < 0.1: # Sehr kleine Toleranz
			return building
	
	return null
	
#endregion
