extends Node

class_name EconomyManager

static var money: float = 1000.0

static func add_money(amount: float):
	money += amount

static func reduce_money(amount: float):
	money -= amount
