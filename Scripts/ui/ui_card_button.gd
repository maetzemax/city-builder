extends Button

class_name UICardButton

@export var category: BuildingCategoryData
@export var building: BuildingData

func _ready():
	if building:
		pressed.connect(_on_building_pressed)
		icon = building.icon
		text = building.display_name
	elif category:
		pressed.connect(_on_category_pressed)
		icon = category.icon
		text = category.display_name

func _on_category_pressed():
	pass

func _on_building_pressed():
	Builder.selected_building = building
