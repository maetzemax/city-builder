extends Building

class_name ResourceNodeData

@export var resource_type: ProductionBuildingData.ResourceType
@export var max_amount: int = 100

## How many ticks need to parse until respawn.
@export var respawn_time: int = 20
@export var respawn_enabled: bool = true
