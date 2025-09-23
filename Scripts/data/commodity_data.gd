extends Resource

class_name CommodityData

enum TYPE {
	WOOD = 0,
	STONE = 1
}

@export var id: int
@export var label: String
## Amount of how much items can be gained
@export var capacity: int
## Which type of commodity
@export var type: TYPE

func get_type_name() -> String:
	var type_name: String = ""
	match type:
		0: type_name = "Wood"
		1: type_name = "Stone"
	
	return type_name
