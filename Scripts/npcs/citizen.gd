extends NPCController

class_name Citizen

signal arrived_at_home
signal arrived_at_work

enum Activity {
	HOME,
	WORKING,
	WALKING,
}

enum Jobs {
	LUMBERJACK,
}

const HOME = 0
const WORKING = 1
const WALKING = 2

@export var full_name: String = "Hans Joachim Peter"
@export var age: int = 18

var current_activity: Activity

var workplace: Vector3
var home: Vector3

# Cached building references for performance
var _workplace_building: Building
var _home_building: Building


func _ready():
	super._ready()
	add_to_group("citizens")

func _process(_delta):
	
	match current_activity:
		HOME:
			visible = false
		WORKING:
			visible = true
		WALKING:
			visible = true
	
	if current_activity == WALKING and nav_agent.target_position == workplace and nav_agent.distance_to_target() < 2:
		arrived_at_work.emit()
		current_activity = Activity.WORKING
		
	if current_activity == WALKING and nav_agent.target_position == home and nav_agent.distance_to_target() < 2:
		arrived_at_home.emit()
		current_activity = Activity.HOME

#region Save/Load System
func get_save_data() -> Dictionary:
	var data = super.get_save_data()
	data.merge({
		"full_name": full_name,
		"age": age,
		"current_activity": current_activity,
		"workplace": workplace,
		"home": home,
	})
	return data

func load_from_data(data: Dictionary):
	super.load_from_data(data)
	full_name = data.get("full_name", "Hans Joachim Peter")
	age = data.get("age", 18)
	current_activity = data.get("current_activity", Activity.HOME)
	workplace = data.get("workplace", Vector3.ZERO)
	home = data.get("home", Vector3.ZERO)
#endregion
