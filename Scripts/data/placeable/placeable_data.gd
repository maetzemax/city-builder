extends Resource

class_name Placeable

@export var id: int
@export var scene: PackedScene

@export_category("Parameters")
## How much does it cost on purchase
@export var cost: float
## How much will be the upkeep per day
@export var upkeep: float

@export_category("UI")
@export var label: String
@export var icon: Texture2D
