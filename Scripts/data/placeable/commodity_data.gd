extends Placeable

class_name Commodity

## Amount of how much items can be gained
@export var capacity: int

@export_enum("Wood", "Stone", "Food") var type

func get_type_name() -> String:
	var type_name: String = ""
	match type:
		0: type_name = "Wood"
		1: type_name = "Stone"
		2: type_name = "Food"
	
	return type_name
