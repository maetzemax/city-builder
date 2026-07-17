extends BuildingData

class_name ProductionBuildingData

enum ResourceType {
	WOOD,
	STONE
}

@export var max_workers: int = 2

## How many seconds need to pass until product is finished
@export var production_time: int = 5
@export var storage_capacity: int = 100

## Dictionary[ResourceType, int] required to produce one output batch
@export var input_resources: Dictionary = {}
## Dictionary[ResourceType, int] produced per output batch
@export var output_resources: Dictionary = {}
