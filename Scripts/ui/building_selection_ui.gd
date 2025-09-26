extends Control

const BUILDING_CATEGORY_UI = preload("uid://6pqxx8jx213m")

@onready var h_box_container: HBoxContainer = $HBoxContainer

@export var categories: Array[BuildingCategoryData]

func _ready():
	for category in categories:
		var category_ui = BUILDING_CATEGORY_UI.instantiate()
		category_ui.category = category
		h_box_container.add_child(category_ui)
