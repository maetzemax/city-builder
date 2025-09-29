extends BuildingData

class_name ProductionBuildingData

enum ResourceType {
	WOOD,
	STONE
}

const WOOD = 0
const STONE = 1

@export var max_workers: int = 2

## How many ticks need to pass until product is finished
@export var production_time: int = 5
@export var storage_capacity: int = 100

@export var input_resource: ResourceType
@export var export_resource: ResourceType
