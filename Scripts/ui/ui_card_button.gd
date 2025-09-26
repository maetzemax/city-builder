extends Button

class_name UICardButton

@export var category: BuildingCategoryData
@export var building: BuildingData

func _ready():
	if building:
		pressed.connect(_on_building_pressed)
		icon = building.icon
		text = building.display_name
		tooltip_text = "Cost: %2.2f €" % building.construction_cost
	elif category:
		icon = category.icon
		text = category.display_name
		autowrap_mode = TextServer.AUTOWRAP_OFF

func _on_building_pressed():
	Builder.selected_building = building
