extends Node3D

@export var commodity: Commodity

var _harvested_total: int = 0

func harvest(amount: int):
	_harvested_total += amount
	print("Harvested ", amount, "x of ",  commodity.get_type_name(), ", " ,commodity.capacity - _harvested_total, " remaining.")
	
	if _harvested_total > commodity.capacity:
		queue_free()
	
	# TODO: Add the harvested account in production storage
