extends Resource

class_name HarvestData

@export var id: int
@export var label: String

## Marimum amount of workers in the building.
@export var max_workers: int

## Maximum amount of what can be stored.
@export var max_capacity: int

## Targeted commidity to harvest.
@export var target: CommodityData.TYPE

## How much will be harvested from the commidity.
@export var harvest_amount: int

@export var working_radius: float
