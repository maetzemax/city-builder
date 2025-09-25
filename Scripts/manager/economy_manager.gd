extends Node

class_name EconomyManager

const START_MONEY: float = 1000.0

static var money: float = START_MONEY

static func add_money(amount: float):
	money += amount

static func reduce_money(amount: float):
	money -= amount

static func reset_money():
	money = START_MONEY
