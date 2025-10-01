extends BuildingData

class_name StorageBuildingData

@export var storage_capacity: int = 500
@export var accepted_resources: Array[ProductionBuildingData.ResourceType] = [] # empty = all

@export var detection_radius: float = 5.0
