class_name WorkingShift
extends Resource

@export var start_hour: int = 8
@export var end_hour: int = 16
		
func get_save_data() -> Dictionary:
	return {
		"start_hour": start_hour,
		"end_hour": end_hour,
	}
		
func load_from_data(data: Dictionary):
	start_hour = data.get("start_hour", 8)
	end_hour = data.get("end_hour", 16)
