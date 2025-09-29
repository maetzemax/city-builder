class_name Citizen
extends NPCController

signal arrived_at_home
signal arrived_at_work

enum Activity {
	HOME,
	WORKING,
	WALKING,
}

enum Jobs {
	LUMBERJACK,
	WAREHOUSE,
}

const HOME = 0
const WORKING = 1
const WALKING = 2

@export var full_name: String = "Hans Joachim Peter"
@export var age: int = 18

var current_activity: Activity = Activity.WORKING

# Cached building references for performance
var _workplace_building: Building
var _home_building: Building


func _ready():
	super._ready()
	add_to_group("citizens")


func _process(_delta):
	if not _home_building:
		update_home_place()
		walk_home()
		
	if not _workplace_building:
		update_working_place()
	
	match current_activity:
		HOME:
			visible = false
		WORKING:
			visible = true
		WALKING:
			visible = true
	
	if current_activity == WALKING and nav_agent.target_position == _workplace_building.npc_spawn_point.global_position and nav_agent.distance_to_target() < 2:
		arrived_at_work.emit()
		current_activity = Activity.WORKING
		
	if current_activity == WALKING and nav_agent.target_position == _home_building.npc_spawn_point.global_position and nav_agent.distance_to_target() < 2:
		arrived_at_home.emit()
		current_activity = Activity.HOME

func update_working_place():
	var buildings = get_tree().get_nodes_in_group("production_buildings")
	
	var shortest_distance: float
	var temp_building: Building = null
	
	for building in buildings:
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
			
	_workplace_building = temp_building


func update_home_place():
	var buildings = get_tree().get_nodes_in_group("residental_buildings")
	
	var shortest_distance: float
	var temp_building: Building = null
	
	for building in buildings:
		if not temp_building:
			temp_building = building
			shortest_distance = building.global_position.distance_to(global_position)
			
		if building.global_position.distance_to(global_position) < shortest_distance:
			temp_building = building
	
	_home_building = temp_building


func walk_to_work():
	set_target_position(_workplace_building.npc_spawn_point.global_position)
	current_activity = Activity.WALKING


func walk_home():
	set_target_position(_home_building.npc_spawn_point.global_position)
	current_activity = Activity.WALKING

#region Save/Load System
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"full_name": full_name,
		"age": age,
		"current_activity": current_activity,
	})
	return data

func load_from_data(data: Dictionary):
	super.load_from_data(data)
	full_name = data.get("full_name", "Hans Joachim Peter")
	age = data.get("age", 18)
	current_activity = data.get("current_activity", Activity.HOME)
#endregion
