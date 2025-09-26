extends Resource

class_name BuildingData

@export var building_id: int

@export_category("Parameters")
## How much does it cost on purchase
@export var construction_cost: float
## How much will be the upkeep per day
@export var upkeep_cost: float

@export_category("UI")
@export var display_name: String
@export var icon: Texture2D
