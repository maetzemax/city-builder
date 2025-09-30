class_name Citizen
extends NPCController

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
var _home_building: ResidentialBuilding

func _ready():
	super._ready()
	add_to_group("citizens")
	visible = false


func _process(_delta):
	if not _home_building:
		update_home_place()
		
	if not _workplace_building:
		update_working_place()
	
	if _workplace_building:
		var time = GameManager.day_progress * 24
		var shift = _workplace_building.shift
		
		var is_working_time = time > shift.start_hour and time < shift.end_hour
		var is_traveling_to_work = current_state == CitizenState.TRAVELING_TO_WORK
		var is_working = current_state == CitizenState.WORKING
		
		if is_working_time and not is_traveling_to_work and not is_working:
			walk_to_work()
	
	match current_state:
		CitizenState.RESTING, CitizenState.UNEMPLOYED, CitizenState.WORKING:
			visible = false
			
		CitizenState.TRAVELING_TO_WORK:
			visible = true
			set_target_position(_workplace_building.npc_spawn_point.global_position)
			
			if nav_agent.distance_to_target() < 2:
				arrived_at_work.emit()
				_workplace_building.add_current_worker(self)
				current_state = CitizenState.WORKING
				
		CitizenState.TRAVELING_TO_HOME:
			visible = true
			set_target_position(_home_building.npc_spawn_point.global_position)
			
			if nav_agent.distance_to_target() < 2:
				arrived_at_work.emit()
				_home_building.add_current_citizen(self)
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
			if not _workplace_building:
				return

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
		if building.is_preview or building.assigned_workers.size() == building.building_data.max_workers:
			continue
			
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
			
	if temp_building:
		_workplace_building = temp_building
		_workplace_building.add_assigned_worker(self)
		current_state = CitizenState.RESTING


func update_home_place():
	var buildings = get_tree().get_nodes_in_group("residental_buildings")
	
	var shortest_distance: float
	var temp_building: Building = null
	
	for building in buildings:
		if building.is_preview:
			break
		
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
	
	if temp_building:
		_home_building = temp_building


func walk_to_work():
	if _workplace_building:
		current_state = CitizenState.TRAVELING_TO_WORK


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

	restore_building_references(data)


func restore_building_references(data: Dictionary):
	var workplace_pos = data.get("workplace_position", Vector3.ZERO)
	var home_pos = data.get("home_position", Vector3.ZERO)
	
	if workplace_pos != Vector3.ZERO:
		_workplace_building = find_building_at_position(workplace_pos, "production_buildings")
		if _workplace_building:
			_workplace_building.add_assigned_worker(self)
	
	if home_pos != Vector3.ZERO:
		_home_building = find_building_at_position(home_pos, "residental_buildings")
		if _home_building:
			_home_building.add_assigned_citizen(self)


func find_building_at_position(target_pos: Vector3, group_name: String) -> Building:
	var buildings = get_tree().get_nodes_in_group(group_name)
	
	for building in buildings:
		if building.global_position.distance_to(target_pos) < 0.3: # Sehr kleine Toleranz
			return building
	
	return null
	
#endregion
