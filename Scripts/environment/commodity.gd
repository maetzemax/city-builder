extends Area3D

class_name Commodity

@export var data: CommodityData

var _harvested_total: int = 0

var is_active: bool = false

func harvest(amount: int):
	if not is_active:
		return
	
	_harvested_total += amount
	print("Harvested ", amount, "x of ",  data.get_type_name(), ", " , data.capacity - _harvested_total, " remaining.")
	print("----------")
	
	EconomyManager.add_money(5)
	
	if _harvested_total >= data.capacity:
		queue_free()
	
	# TODO: Add the harvested account in production storage
