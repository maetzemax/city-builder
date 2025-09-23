extends Node

class_name EconomyManager

@export var label: Label

static var money: float = 1000.0

static func add_money(amount: float):
	money += amount

static func reduce_money(amount: float):
	money -= amount
	
func _ready():
	# Load money value from the map save file
	return

func _process(_delta):
	label.text = "%2.2f €" % money
